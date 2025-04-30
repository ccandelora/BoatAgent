class BoatsController < ApplicationController
  before_action :require_login
  before_action :set_boat, only: [ :show, :edit, :update, :destroy ]
  before_action :ensure_boat_owner, only: [ :edit, :update, :destroy ]

  def index
    @boats = current_user.boats
  end

  def show
    @maintenance_tasks = @boat.maintenance_tasks.order(due_date: :asc)
    @upcoming_tasks = @boat.maintenance_tasks.where("due_date >= ?", Date.today).order(due_date: :asc).limit(5) rescue []
    @overdue_tasks = @boat.maintenance_tasks.where("due_date < ?", Date.today).order(due_date: :asc).limit(5) rescue []

    # Initialize empty collections if they don't exist yet
    @maintenance_tasks ||= []
    @upcoming_tasks ||= []
    @overdue_tasks ||= []
  end

  def new
    @boat = current_user.boats.build
  end

  def create
    @boat = current_user.boats.build(boat_params)

    if @boat.save
      generate_maintenance_recommendations(@boat)
      redirect_to boat_ai_recommendations_path(@boat, auto_generated: true),
                  notice: "Boat was successfully created. Maintenance recommendations have been generated!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @boat.update(boat_params)
      if significant_changes?
        generate_maintenance_recommendations(@boat)
        redirect_to boat_ai_recommendations_path(@boat, auto_generated: true),
                    notice: "Boat was successfully updated. Maintenance recommendations have been regenerated."
      else
        redirect_to @boat, notice: "Boat was successfully updated."
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @boat.destroy
    redirect_to boats_path, notice: "Boat was successfully deleted."
  end

  private

  def set_boat
    @boat = Boat.find(params[:id])
  end

  def ensure_boat_owner
    unless @boat.user == current_user
      redirect_to boats_path, alert: "You don't have permission to modify that boat."
    end
  end

  def boat_params
    params.require(:boat).permit(:name, :make, :model, :year, :engine_type, :location, :hours, :description)
  end

  def generate_maintenance_recommendations(boat)
    service = OpenaiService.new
    recommendations = service.generate_maintenance_recommendations(boat)

    saved_count = 0
    recommendations.each do |rec|
      saved_count += 1 if rec.save
    end

    Rails.logger.info "Generated #{saved_count} maintenance recommendations for boat #{boat.id}"
  end

  def significant_changes?
    # Check if any fields that would affect maintenance were updated
    @boat.saved_changes.keys.any? { |k| [ "make", "model", "year", "engine_type", "hours" ].include?(k) }
  end
end
