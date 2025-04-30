class SystemComponentsController < ApplicationController
  before_action :require_login
  before_action :set_system_component, only: [ :show, :edit, :update, :destroy ]
  before_action :check_admin, only: [ :new, :create, :edit, :update, :destroy ]

  def index
    @system_components = SystemComponent.all.order(:name)
  end

  def show
    @maintenance_tasks = MaintenanceTask.where(system_component: @system_component).order(created_at: :desc)
  end

  def new
    @system_component = SystemComponent.new
  end

  def create
    @system_component = SystemComponent.new(system_component_params)

    if @system_component.save
      redirect_to @system_component, notice: "System component was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @system_component.update(system_component_params)
      redirect_to @system_component, notice: "System component was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @system_component.maintenance_tasks.exists?
      redirect_to @system_component, alert: "Cannot delete component that has associated maintenance tasks."
    else
      @system_component.destroy
      redirect_to system_components_path, notice: "System component was successfully deleted."
    end
  end

  private

  def set_system_component
    @system_component = SystemComponent.find(params[:id])
  end

  # In a real app, you'd implement proper admin roles
  # This is a simplified version for the demo
  def check_admin
    # For now, let any logged in user manage components
    # In production, you'd check for admin role
    true
  end

  def system_component_params
    params.require(:system_component).permit(:name, :description)
  end
end
