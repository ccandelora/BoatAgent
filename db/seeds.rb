# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create system components
components = [
  { name: "Engine", description: "The boat's primary propulsion system" },
  { name: "Hull", description: "The watertight body of the boat" },
  { name: "Electrical", description: "All electrical components and wiring" },
  { name: "Plumbing", description: "Water and waste systems" },
  { name: "Rigging", description: "Masts, sails, lines, and related equipment" },
  { name: "Navigation", description: "Charts, GPS, radar, and other navigational equipment" },
  { name: "Safety", description: "Life vests, fire extinguishers, and emergency equipment" },
  { name: "Interior", description: "Cabin and interior components" },
  { name: "Exterior", description: "Deck, railings, seating, and other exterior components" }
]

components.each do |component|
  SystemComponent.find_or_create_by!(name: component[:name]) do |c|
    c.description = component[:description]
  end
end

puts "Created #{SystemComponent.count} system components"

# Create a demo user if in development
if Rails.env.development?
  demo_user = User.find_or_create_by!(email: "demo@example.com") do |user|
    user.password = "password"
    user.password_confirmation = "password"
  end

  puts "Created demo user: demo@example.com / password"

  # Create a demo boat
  unless demo_user.boats.exists?
    boat = demo_user.boats.create!(
      name: "Sea Breeze",
      make: "Boston Whaler",
      model: "Montauk 170",
      year: 2019,
      engine_type: "Yamaha 90HP Outboard",
      location: "Massachusetts",
      hours: 120,
      description: "Family fishing boat in great condition"
    )

    puts "Created demo boat: #{boat.name}"

    # Create some maintenance tasks
    tasks = [
      {
        title: "Oil Change",
        description: "Change engine oil and filter",
        due_date: Date.today + 2.weeks,
        cost: 89.95,
        engine_hours: 150,
        notes: "Use Yamaha 10W-30 marine oil",
        system_component: SystemComponent.find_by(name: "Engine")
      },
      {
        title: "Bottom Paint",
        description: "Apply fresh antifouling paint",
        due_date: Date.today - 2.days,
        cost: 350.00,
        notes: "Use blue Pettit Trinidad SR",
        system_component: SystemComponent.find_by(name: "Hull")
      },
      {
        title: "Safety Inspection",
        description: "Check all safety equipment and replace expired items",
        completed_at: 2.months.ago,
        cost: 75.00,
        notes: "Replaced fire extinguisher and emergency flares",
        system_component: SystemComponent.find_by(name: "Safety")
      }
    ]

    tasks.each do |task_data|
      boat.maintenance_tasks.create!(task_data)
    end

    puts "Created #{boat.maintenance_tasks.count} maintenance tasks"
  end
end
