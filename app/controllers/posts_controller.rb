class PostsController < ApplicationController
  # автоматическая проверка залогирован ли пользователь с помощью devise
  before_action :authenticate_user!, except: [:index, :show]
  # фильтр before_action перед выполнением действий show... вызывается метод set_post
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :authorize_admin!, only: [:new, :create, :edit, :update, :destroy]


  # include Pundit::Authorization

  def index
    # Все статьи на главной странице
    @posts = Post.all
  end

  def new
    # Метод new для создания posts/new формы для создания новых постов
    @post = current_user.posts.new
    #authorize @post if defined?(Pundit)
  end

  def show
    # Создание метода show для того чтобы после заполнения формы поста, вернулось и показать сам созданный пост
    #authorize @post if defined?(Pundit)
  end

  def edit
    #authorize @post
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
    # если все проверки пройдены то пост будет создан, связанный с текущим пользователем
    @post = current_user.posts.new(post_params)
    # проверка на право создавать посты, если вошел в систему
    authorize @post
    # проверка пользователя на авторизацию, если не вошел в систему перенаправляется на страницу входа

    # respond_to позволяет контроллеру отвечать по разному, в зависимости от типа запроса
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
    params.require(:post).permit(:title, :body, :post_data)
  end

  def authorize_admin!
    return if current_user.admin?

    redirect_to root_path, alert: "Dostep zabroniony"
  end
end



=begin
  def create
    # Создание метода create, взять переменную экземпляра после @, для создания нового поста, сделать
    # приватный метод post_params с параметрами поста отдельно, и вписать метод при создании поста.
    # Далее сохранение поста, и возвращение на сам сохраненный пост

    # render plain: params[:post].inspect

    @post = Post.new(post_params)

    # проверка валидации если неправильное введение данных для поста
    if @post.save
      redirect_to @post
    else
      render 'new'
    end
  end

  private

  def post_params
    # параметры для метода post
    params.require(:post).permit(:title, :body)
  end
=end