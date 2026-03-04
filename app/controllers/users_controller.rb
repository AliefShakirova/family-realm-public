class UsersController < ApplicationController

  def show

    sign_out :user
    redirect_to root_path
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.welcome_email(@user).deliver_later
      redirect_to @user, notice: 'User was successfully created.'
    else
      render :new
    end
  end
end
