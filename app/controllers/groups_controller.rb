class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  before_action :authorize_owner, only: [:edit, :update, :destroy]

  def index
    @groups = current_user.groups
  end

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

    existing_user = User.find_by(email: email)
    if existing_user && @group.members.include?(existing_user)
      redirect_to @group, alert: "Пользователь уже состоит в группе"
      return
    end

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

  def members
    @group = Group.find(params[:id])
  end

  def tree
    @group = Group.find(params[:id])
    @ancestors = @group.ancestors

    @chart_data = "graph TD\n"

    @ancestors.each do |person|
      @chart_data += "  Node#{person.id}[\"#{person.full_name}\"]\n"
    end

    @ancestors.each do |person|
      if person.father_id.present?
        @chart_data += "  Node#{person.father_id} --> Node#{person.id}\n"
      end

      if person.mother_id.present?
        @chart_data += "  Node#{person.mother_id} --> Node#{person.id}\n"
      end
    end
  end

  def make_connection
    @group = Group.find(params[:id])

    child = @group.ancestors.find_by(id: params[:child_id])
    parent = @group.ancestors.find_by(id: params[:parent_id])

    if child && parent
      if params[:role] == 'mother'
        child.update(mother_id: parent.id)
      elsif params[:role] == 'father'
        child.update(father_id: parent.id)
      end
    end

    redirect_to tree_group_path(@group), notice: "Связь успешно создана! Древо обновлено."
  end

  def timeline
    @group = Group.find(params[:id])
    @ancestors = @group.ancestors

    events = @group.timeline_events.to_a

    @ancestors.each do |person|
      if person.birth_date.present?
        events << TimelineEvent.new(
          event_date: person.birth_date,
          title: "🌟 Рождение",
          description: "Появление на свет: #{person.full_name}",
          ancestor_id: person.id
        )
      end

      if person.respond_to?(:death_date) && person.death_date.present?
        events << TimelineEvent.new(
          event_date: person.death_date,
          title: "🕊️ Смерть",
          description: "Скончался(ась): #{person.full_name}",
          ancestor_id: person.id
        )
      end
    end

    @timeline_events = events.sort_by { |e| e.event_date || Date.today }
  end

  def add_timeline_event
    @group = Group.find(params[:id])

    @event = @group.timeline_events.build(
      title: params[:title],
      event_date: params[:event_date],
      description: params[:description],
      ancestor_id: params[:ancestor_id]
    )

    if @event.save
      redirect_to timeline_group_path(@group), notice: "Событие успешно добавлено на ось времени!"
    else
      redirect_to timeline_group_path(@group), alert: "Ошибка: проверьте правильность заполнения полей (название и дата обязательны)."
    end
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
