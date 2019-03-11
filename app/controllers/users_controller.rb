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
    @microposts = @user.microposts.paginate page: params[:page]
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = I18n.t "please_check_email"
      redirect_to root_url
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

  def following
    @title = I18n.t "following"
    @user = User.find_by id: params[:id]
    @users = @user.following.paginate page: params[:page]
    render :show_follow
  end

  def followers
    @title = I18n.t "followers"
    @user = User.find_by id: params[:id]
    @users = @user.followers.paginate page: params[:page]
    render :show_follow
  end

  private
    def user_params
      params.require(:user).permit :name, :email, :password,
        :password_confirmation
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
