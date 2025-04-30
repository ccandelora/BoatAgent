class HomeController < ApplicationController
  before_action :require_login, except: [ :index ]

  def index
    if logged_in?
      # Gather dashboard data
      @boats = current_user.boats

      if @boats.any?
        # Get upcoming and overdue tasks across all boats
        @upcoming_tasks = MaintenanceTask.where(boat_id: @boats.pluck(:id))
                                       .upcoming
                                       .includes(:boat, :system_component)
                                       .limit(5)

        @overdue_tasks = MaintenanceTask.where(boat_id: @boats.pluck(:id))
                                      .overdue
                                      .includes(:boat, :system_component)
                                      .limit(5)

        # Get recent AI recommendations
        @recent_recommendations = AiRecommendation.where(boat_id: @boats.pluck(:id))
                                               .upcoming
                                               .order(created_at: :desc)
                                               .includes(:boat, :system_component)
                                               .limit(5)
      end

      render :dashboard
    else
      # Show welcome/marketing page for non-logged in users
      render :welcome
    end
  end
end
