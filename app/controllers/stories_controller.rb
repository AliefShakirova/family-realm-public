class StoriesController < ApplicationController
  before_action :set_group
  before_action :set_story, only: [:show, :edit, :update, :destroy]

  def index
    @stories = @group.stories.order(created_at: :desc)
  end

  def show
  end

  def new
    @story = @group.stories.build
  end

  def edit
  end

  def create
    @story = @group.stories.build(story_params)
    @story.user = current_user

    if @story.save
      redirect_to group_stories_path(@group), notice: "История успешно сохранена!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @story.update(story_params)
      redirect_to group_story_path(@group, @story), notice: "История обновлена."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @story.destroy
    redirect_to group_stories_path(@group), notice: "История удалена."
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_story
    @story = @group.stories.find(params[:id])
  end

  def story_params
    params.require(:story).permit(:title, :content, :story_date, ancestor_ids: [], media: [])
  end
end
