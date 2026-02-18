class RelationshipsController < ApplicationController
  before_action :set_group
  before_action :set_ancestor

  def new
    @relationship = @ancestor.relationships.build
    @possible_relatives = @group.ancestors.where.not(id: @ancestor.id)
  end

  def create
    @relationship = @ancestor.active_relationships.build(relationship_params)
    @relationship.group = @group # Привязываем к той же группе

    if @relationship.save
      redirect_to group_ancestor_path(@group, @ancestor), notice: "Связь добавлена!"
    else
      redirect_to group_ancestor_path(@group, @ancestor), alert: "Ошибка добавления связи."
    end
  end

  def destroy
    @relationship = @ancestor.active_relationships.find(params[:id])
    @relationship.destroy
    redirect_to group_ancestor_path(@group, @ancestor), notice: "Связь удалена."
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_ancestor
    @ancestor = @group.ancestors.find(params[:ancestor_id])
  end

  def relationship_params
    params.require(:relationship).permit(:relative_id, :relation_type)
  end
end
