class AncestorsController < ApplicationController
  before_action :set_group
  before_action :set_ancestor, only: [:show, :edit, :update, :destroy, :delete_document]

  def index
    @ancestors = @group.ancestors
  end

  def show
    @new_relationship = Relationship.new
  end

  def new
    @ancestor = @group.ancestors.build
  end

  def create
    @ancestor = @group.ancestors.build(ancestor_params)

    if @ancestor.save

      @ancestor.documents.attach(params[:ancestor][:documents]) if params[:ancestor][:documents].present?

      redirect_to [@group, @ancestor], notice: "Предок создан"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @ancestor.update(ancestor_params.except(:documents))
      @ancestor.documents.attach(params[:ancestor][:documents]) if params[:ancestor][:documents].present?

      redirect_to [@group, @ancestor], notice: "Предок обновлён"
    else
      render :edit
    end
  end

  def destroy
    @ancestor.destroy
    redirect_to group_ancestors_path(@group), notice: "Удалено"
  end

  def purge_document
    @group = Group.find(params[:group_id])
    @ancestor = @group.ancestors.find(params[:id])

    @document = @ancestor.documents.find(params[:attachment_id])

    @document.purge

    redirect_to edit_group_ancestor_path(@group, @ancestor), notice: "Документ удален."
  end

  private

  def set_group
    @group = Group.find(params[:group_id])
  end

  def set_ancestor
    @ancestor = @group.ancestors.find(params[:id])
  end

  def ancestor_params
    params.require(:ancestor).permit(
      :first_name,
      :last_name,
      :middle_name,
      :avatar,
      :birth_date,
      :alive,
      :phone,
      :current_address,
      :death_date,
      :death_place,
      :birth_place,
      :description,
      :photo,
      :father_id,
      :mother_id,
      documents: []
    )
  end
end
