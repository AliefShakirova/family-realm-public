class LocationsController < ApplicationController
  before_action :authenticate_user! # Если у тебя есть Devise, чтобы гости не лезли
  before_action :set_group
  before_action :set_location, only: [:show, :edit, :update, :destroy]

  def index
    @locations = @group.locations
  end

  def show
  end

  def new
    @location = @group.locations.build
  end

  def edit
  end

  def create
    @location = @group.locations.build(location_params)

    if @location.save
      redirect_to group_locations_path(@group), notice: "Место успешно создано."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @location.update(location_params)
      redirect_to group_locations_path(@group), notice: "Место обновлено."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @location.destroy
    redirect_to group_locations_path(@group), notice: "Место удалено."
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_location
    @location = @group.locations.find(params[:id])
  end

  def location_params
    params.require(:location).permit(:name, :address, :description)
  end
end
