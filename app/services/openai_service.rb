class OpenaiService
  attr_reader :client

  def initialize
    api_key = Rails.application.credentials.dig(:openai, :api_key) || ENV["OPENAI_API_KEY"]

    if api_key.present? && api_key.start_with?("sk-")
      @client = OpenAI::Client.new(access_token: api_key)
      Rails.logger.info "OpenAI client initialized with valid API key"
    else
      Rails.logger.warn "No valid OpenAI API key found (got: #{api_key.present? ? "Invalid format" : "No key"}). Using mock responses."
      @client = nil
    end
  end

  def chat(prompt, system_message = nil)
    messages = []

    if system_message.present?
      messages << { role: "system", content: system_message }
    else
      messages << { role: "system", content: default_system_message }
    end

    messages << { role: "user", content: prompt }

    # Return a mock response if no valid API key is configured
    return mock_response(prompt) if mock_mode?

    response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: messages,
        temperature: 0.7,
        max_tokens: 500
      }
    )

    response.dig("choices", 0, "message", "content")
  rescue => e
    Rails.logger.error "OpenAI API error: #{e.message}"
    "I'm sorry, I couldn't process your request at this time. Please try again later."
  end

  def generate_maintenance_recommendations(boat)
    system_message = "You are a marine technician AI assistant. Recommend maintenance tasks for a boat with the following details:"

    prompt = <<~PROMPT
      Boat: #{boat.name}
      Make: #{boat.make}
      Model: #{boat.model}
      Year: #{boat.year}
      Engine Type: #{boat.engine_type}
      Current Hours: #{boat.hours || 'Unknown'}
      Location: #{boat.location || 'Unknown'}

      Please suggest 3-5 maintenance tasks that should be performed in the next 3 months.
      Format each task with:
      - Title
      - Description
      - Task Type (routine, seasonal, preventive, repair, or upgrade)
      - Suggested date
      - System component (engine, hull, electrical, plumbing, rigging, etc.)
    PROMPT

    Rails.logger.info "Generating recommendations for boat: #{boat.name} (using #{mock_mode? ? 'mock' : 'API'} mode)"
    response = chat(prompt, system_message)
    recommendations = parse_maintenance_recommendations(response, boat)
    Rails.logger.info "Generated #{recommendations.size} recommendations"

    recommendations
  end

  private

  def default_system_message
    "You are a marine technician AI assistant specialized in boat maintenance. Provide helpful, accurate advice about boat care, maintenance schedules, and repairs."
  end

  def parse_maintenance_recommendations(response, boat)
    recommendations = []

    # Simple parsing logic - this could be improved with regex or more sophisticated parsing
    sections = response.split(/Task \d+:|^\d+\./).reject(&:blank?)

    sections.each do |section|
      lines = section.split("\n").map(&:strip).reject(&:blank?)
      next if lines.empty?

      title = extract_info(lines, "Title:")
      description = extract_info(lines, "Description:")
      task_type = extract_info(lines, "Task Type:")
      suggested_date = extract_info(lines, "Suggested date:")
      component_name = extract_info(lines, "System component:")

      next if title.blank?

      # Ensure we have a component name, default to "General" if missing
      component_name = "General" if component_name.blank?

      # Find or create the system component - always create one if not found
      system_component = SystemComponent.find_or_create_by!(name: component_name)

      # Parse the suggested date
      begin
        date = suggested_date.present? ? Date.parse(suggested_date) : (Date.today + 1.month)
      rescue
        date = Date.today + 1.month
      end

      # Create the recommendation
      recommendations << boat.ai_recommendations.build(
        title: title,
        description: description || "No description provided",
        task_type: task_type&.downcase,
        suggested_date: date,
        system_component: system_component
      )
    end

    recommendations
  end

  def extract_info(lines, prefix)
    matching_line = lines.find { |line| line.start_with?(prefix) }
    matching_line&.sub(prefix, "")&.strip
  end

  def mock_mode?
    @client.nil?
  end

  def mock_response(prompt)
    if prompt.include?("suggest 3-5 maintenance tasks")
      # This is a request for maintenance recommendations
      boat_details = prompt.split("\n").first(7)
      generate_mock_maintenance_recommendations(boat_details)
    elsif prompt.downcase.include?("oil change")
      "You should change your boat's engine oil every 100 hours or annually, whichever comes first. Make sure to use marine-grade oil appropriate for your engine type."
    elsif prompt.downcase.include?("winterize")
      "Winterizing your boat involves several key steps: draining water systems, adding antifreeze, stabilizing fuel, changing oil, removing the battery, and covering the boat properly. This should be done before temperatures reach freezing."
    elsif prompt.downcase.match?(/impeller|water pump/i)
      "Impellers should typically be replaced every 2 years or 300 hours of operation. If you notice decreased water flow from the exhaust, it could indicate an impeller issue that needs immediate attention."
    else
      "As a boat maintenance assistant, I recommend establishing a regular maintenance schedule for your vessel. This includes hull cleaning, engine servicing, electrical system checks, and safety equipment inspections. Regular maintenance extends your boat's life and ensures safety on the water."
    end
  end

  def generate_mock_maintenance_recommendations(boat_details)
    # Extract boat make/model for more specific recommendations
    boat_info = {}
    boat_details.each do |line|
      key, value = line.split(":", 2)
      boat_info[key.strip] = value&.strip
    end

    engine_type = boat_info["Engine Type"] || "Unknown"
    is_outboard = engine_type.downcase.include?("outboard")

    recommendations = []

    # Task 1
    recommendations << <<~TASK
      Title: Engine Oil Change
      Description: Regular oil changes are crucial for marine engines. Replace the oil and oil filter according to manufacturer recommendations.
      Task Type: Routine
      Suggested date: #{(Date.today + 2.weeks).strftime("%B %d, %Y")}
      System component: Engine
    TASK

    # Task 2
    recommendations << <<~TASK
      Title: #{is_outboard ? "Lower Unit Lubrication" : "Transmission Fluid Check"}
      Description: #{is_outboard ? "Drain and replace the lower unit gear oil to ensure proper lubrication and prevent corrosion." : "Check transmission fluid levels and condition. Replace if discolored or contaminated."}
      Task Type: Preventive
      Suggested date: #{(Date.today + 1.month).strftime("%B %d, %Y")}
      System component: #{is_outboard ? "Propulsion" : "Transmission"}
    TASK

    # Task 3
    recommendations << <<~TASK
      Title: Battery Inspection and Service
      Description: Clean battery terminals, check water levels in cells (if applicable), and test battery capacity. Replace if showing signs of weakness.
      Task Type: Routine
      Suggested date: #{(Date.today + 3.weeks).strftime("%B %d, %Y")}
      System component: Electrical
    TASK

    # Task 4
    recommendations << <<~TASK
      Title: Hull Cleaning and Waxing
      Description: Remove marine growth, clean the hull, and apply a protective wax coating to prevent UV damage and water absorption.
      Task Type: Seasonal
      Suggested date: #{(Date.today + 1.month + 1.week).strftime("%B %d, %Y")}
      System component: Hull
    TASK

    recommendations.join("\n\n")
  end
end
