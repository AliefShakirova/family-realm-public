class PostsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authorize_admin!, only: [:new, :create, :edit, :update, :destroy]

  def index
    @posts = Post.all
  end

  def new
    @post = current_user.posts.new
  end

  def show
  end

  def edit
  end

  def update

    if @post.update(post_params)
      redirect_to @post, notice: 'Post został zaktualizowany'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy

    redirect_to root_path, notice: 'Post został usunięty'
  end

  def create
    @post = current_user.posts.new(post_params)
    authorize @post

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post został pomyślnie utworzony' } # обычный переход в браузере
        format.json { render :show, status: created, location: @post } # запрос через API
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_post
    @post = Post.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to posts_path, alert: "Nie znaleziono posta"
  end

  def post_params
    params.require(:post).permit(:title, :body, :post_data, :attachment)
  end

  def authorize_admin!
    return if current_user.admin?

    redirect_to root_path, alert: "Dostep zabroniony"
  end
end
