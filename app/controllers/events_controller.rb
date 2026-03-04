class EventsController < ApplicationController
  before_action :set_group
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def index
    @events = @group.events.order(event_date: :asc)
  end

  def show
  end

  def new
    @event = Event.new
    @group = Group.find(params[:group_id])

    @ancestors = @group.ancestors
  end

  def edit
  end

  def create
    @event = @group.events.build(event_params)

    if @event.save
      redirect_to group_events_path(@group), notice: "Событие создано!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @event.update(event_params)
      redirect_to group_events_path(@group), notice: "Событие обновлено."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    redirect_to group_events_path(@group), notice: "Событие удалено."
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_event
    @event = @group.events.find(params[:id])
  end

  def event_params
    params.require(:event).permit(:title, :description, :event_date, :location_id, :location_name, ancestor_ids: [], media: [])
  end
end
