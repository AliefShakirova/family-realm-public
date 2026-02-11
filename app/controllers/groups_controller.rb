class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  before_action :authorize_owner, only: [:edit, :update, :destroy]

  def index
    @groups = current_user.owned_groups
  end

  def show
  end

  def new
    @group = Group.new
  end

  def create
    @group = current_user.owned_groups.build(group_params)

    if @group.save
      redirect_to @group, notice: 'Группа создана'
    else
      render :new
    end
  end

    def edit
    end

  def update
    if @group.update(group_params)
      redirect_to @group, notice: "Группа обновлена"
    else
      render :edit
    end
  end

  def destroy
    @group = Group.find(params[:id])
    @group.destroy
    redirect_to groups_path, notice: "Группа удалена"
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def authorize_owner
    redirect_to groups_path, alert: 'Нет доступа' unless @group.owner == current_user
  end

  def group_params
    params.require(:group).permit(:name, :description, :privacy)
  end
end
