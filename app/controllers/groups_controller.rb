class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  before_action :authorize_owner, only: [:edit, :update, :destroy]

  def index
    @groups = current_user.groups
  end

  #В show проверка доступа к группе
  def show
    @group = Group.find(params[:id])

    unless @group.members.include?(current_user) || @group.owner == current_user
      redirect_to groups_path, alert: "Нет доступа к этой группе"
    end
  end

  def new
    @group = Group.new
  end

  def create
    @group = current_user.owned_groups.build(group_params)

    if @group.save
      GroupMember.create!(
        user: current_user,
        group: @group,
        role: "owner"
      )

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

  def invite
    @group = Group.find(params[:id])

    unless @group.owner == current_user
      redirect_to @group, alert: "Только создатель группы может приглашать"
      return
    end

    email = params[:email]

    # Проверка: уже участник?
    existing_user = User.find_by(email: email)
    if existing_user && @group.members.include?(existing_user)
      redirect_to @group, alert: "Пользователь уже состоит в группе"
      return
    end

    # Проверка: уже есть pending invite?
    if @group.group_invitations.where(email: email, status: "pending").exists?
      redirect_to @group, alert: "Приглашение уже отправлено"
      return
    end

    invitation = @group.group_invitations.create!(
      email: email,
      invited_by: current_user.id
    )

    InvitationMailer.invite(email, @group, invitation.token).deliver_now

    redirect_to @group, notice: "Приглашение отправлено"
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
