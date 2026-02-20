class TimelineEventsController < ApplicationController
  def edit
    @timeline_event = TimelineEvent.find(params[:id])
    @group = @timeline_event.group
    @ancestors = @group.ancestors
  end

  def update
    @timeline_event = TimelineEvent.find(params[:id])
    if @timeline_event.update(event_params)
      redirect_to timeline_group_path(@timeline_event.group), notice: "Событие успешно обновлено!"
    else
      render :edit
    end
  end

  def destroy
    @timeline_event = TimelineEvent.find(params[:id])
    group = @timeline_event.group
    @timeline_event.destroy
    redirect_to timeline_group_path(group), notice: "Событие удалено!"
  end

  private

  def event_params
    params.require(:timeline_event).permit(:title, :event_date, :description, :ancestor_id)
  end
end
