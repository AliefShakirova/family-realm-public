class UserProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user_profile = current_user.user_profile
  end

  def edit
    @user_profile = current_user.user_profile || current_user.build_user_profile
  end

  def update
    @user_profile = current_user.user_profile || current_user.build_user_profile

    if @user_profile.update(user_profile_params)
      redirect_to user_profile_path, notice: 'Profile updated successfully'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_profile_params
    params.require(:user_profile).permit(:first_name, :last_name, :middle_name, :maiden_name,
                                         :birth_date, :place_of_birth, :description, :gender)
  end
end