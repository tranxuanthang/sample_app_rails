class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :find_user, only: [:show, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy


  def index
    @users = User.order_by_name.paginate page: params[:page]
  end

  def new
    @user = User.new
  end

  def show
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = I18n.t "welcome_message"
      redirect_to @user
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update_attributes user_params
      flash[:success] = I18n.t "profile_updated"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    if @user.destroyed?
      flash[:success] = I18n.t "user_deleted"
      redirect_to users_url
    else
      flash.now[:danger] = I18n.t "user_not_deleted"
    end
  end

  private
    def user_params
      params.require(:user).permit :name, :email, :password,
        :password_confirmation
    end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = I18n.t "please_login"
        redirect_to login_url
      end
    end

    def correct_user
      @user = User.find_by id: params[:id]
      redirect_to root_url unless @user.current_user? current_user
    end

    def admin_user
      redirect_to root_url unless current_user.admin?
    end

    def find_user
      @user = User.find_by id: params[:id]
      if !@user
        flash[:danger] = I18n.t "user_not_found"
        redirect_to root_url
      end
    end
end
