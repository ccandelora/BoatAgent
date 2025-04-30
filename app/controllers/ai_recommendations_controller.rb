class AiRecommendationsController < ApplicationController
  before_action :require_login
  before_action :set_boat
  before_action :set_recommendation, only: [ :show, :convert ]
  before_action :ensure_boat_owner

  def index
    @ai_recommendations = @boat.ai_recommendations.upcoming

    # Show a message if recommendations were automatically generated
    if params[:auto_generated]
      flash.now[:recommendation_notice] = "AI has automatically generated maintenance recommendations based on your boat's specifications."
    end

    # Generate new recommendations if none exist or if explicitly requested
    if params[:generate] == "true" || @ai_recommendations.empty?
      generate_recommendations
    end
  end

  def show
  end

  def convert
    maintenance_task = @recommendation.convert_to_task!

    if maintenance_task.persisted?
      redirect_to boat_maintenance_task_path(@boat, maintenance_task),
                  notice: "Recommendation converted to maintenance task."
    else
      redirect_to boat_ai_recommendation_path(@boat, @recommendation),
                  alert: "Could not create maintenance task: #{maintenance_task.errors.full_messages.join(', ')}"
    end
  end

  private

  def set_boat
    @boat = Boat.find(params[:boat_id])
  end

  def set_recommendation
    @recommendation = @boat.ai_recommendations.find(params[:id])
  end

  def ensure_boat_owner
    unless @boat.user == current_user
      redirect_to boats_path, alert: "You don't have permission to access that boat's recommendations."
    end
  end

  def generate_recommendations
    service = OpenaiService.new
    new_recommendations = service.generate_maintenance_recommendations(@boat)

    if new_recommendations.any?
      saved_count = 0
      new_recommendations.each do |rec|
        saved_count += 1 if rec.save
      end

      flash[:notice] = "Generated #{saved_count} new maintenance recommendations."
    else
      flash[:alert] = "Could not generate recommendations at this time."
    end

    @ai_recommendations = @boat.ai_recommendations.upcoming
  end
end
