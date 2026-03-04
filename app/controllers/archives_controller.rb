class ArchivesController < ApplicationController
  before_action :set_archive, only: %i[ show edit update destroy ]
  before_action :check_admin, except: %i[ index show]

  def index
    @archives = Archive.all
  end

  def show
  end

  def new
    @archive = Archive.new
  end

  def edit
  end

  def create
    @archive = Archive.new(archive_params)

    respond_to do |format|
      if @archive.save
        format.html { redirect_to @archive, notice: "Archive was successfully created." }
        format.json { render :show, status: :created, location: @archive }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @archive.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @archive.update(archive_params)
        format.html { redirect_to @archive, notice: "Archive was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @archive }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @archive.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @archive.destroy!

    respond_to do |format|
      format.html { redirect_to archives_path, notice: "Archive was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  def set_archive
    @archive = Archive.find(params[:id])
  end

  def archive_params
    params.require(:archive).permit(:title, :description, :gubernia, :year, :document)
  end

  def check_admin
    unless current_user && current_user.admin?
      redirect_to archives_path, alert: "У вас нет прав для добавления или изменения документов. Это может делать только администратор."
    end
  end
end
