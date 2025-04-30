class MaintenanceTasksController < ApplicationController
  before_action :require_login
  before_action :set_boat
  before_action :set_maintenance_task, only: [:show, :edit, :update, :destroy, :complete, :uncomplete]
  before_action :ensure_boat_owner

  def index
    @maintenance_tasks = @boat.maintenance_tasks.order(due_date: :asc)
    @completed_tasks = @boat.maintenance_tasks.completed.order(completed_at: :desc)
    @pending_tasks = @boat.maintenance_tasks.pending.order(due_date: :asc)
  end

  def show
  end

  def new
    @maintenance_task = @boat.maintenance_tasks.build
    @system_components = SystemComponent.all
  end

  def create
    @maintenance_task = @boat.maintenance_tasks.build(maintenance_task_params)

    if @maintenance_task.save
      redirect_to [@boat, @maintenance_task], notice: "Maintenance task was successfully created."
    else
      @system_components = SystemComponent.all
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @system_components = SystemComponent.all
  end

  def update
    if @maintenance_task.update(maintenance_task_params)
      redirect_to [@boat, @maintenance_task], notice: "Maintenance task was successfully updated."
    else
      @system_components = SystemComponent.all
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @maintenance_task.destroy
    redirect_to boat_maintenance_tasks_path(@boat), notice: "Maintenance task was successfully deleted."
  end

  def complete
    @maintenance_task.complete!
    redirect_to [@boat, @maintenance_task], notice: "Task marked as completed."
  end

  def uncomplete
    @maintenance_task.uncomplete!
    redirect_to [@boat, @maintenance_task], notice: "Task marked as pending."
  end

  private

  def set_boat
    @boat = Boat.find(params[:boat_id])
  end

  def set_maintenance_task
    @maintenance_task = @boat.maintenance_tasks.find(params[:id])
  end

  def ensure_boat_owner
    unless @boat.user == current_user
      redirect_to boats_path, alert: "You don't have permission to modify that boat's maintenance tasks."
    end
  end

  def maintenance_task_params
    params.require(:maintenance_task).permit(
      :title, :description, :due_date, :cost, :engine_hours,
      :notes, :system_component_id, :photo
    )
  end
end
