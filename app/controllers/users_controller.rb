class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def show
    @user = User.find_by id: params[:id]
    if !@user
      flash[:danger] = I18n.t "user_not_found"
    end
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = I18n.t "welcome_message"
      redirect_to @user
    else
      render :new
    end
  end

  private
    def user_params
      params.require(:user).permit :name, :email, :password,
        :password_confirmation
    end
end
