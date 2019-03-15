class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase
    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = I18n.t "password_reset_email_sent"
      redirect_to root_url
    else
      flash.now[:danger] = "email_not_found"
      render :new
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add :password, I18n.t("empty_error")
      render :edit
    elsif @user.update user_params
      log_in @user
      @user.update reset_digest: nil
      flash[:success] = I18n.t "reset_success"
      redirect_to @user
    else
      render :edit
    end
  end

  private
    def user_params
      params.require(:user).permit :password, :password_confirmation
    end

    def get_user
      @user = User.find_by email: params[:email]
      return if @user
      flash[:danger] = I18n.t "user_not_found"
      redirect_to root_url
    end

    def valid_user
      unless @user&.activated? &&
        @user.authenticated?(:reset, params[:id])
        redirect_to root_url
      end
    end

    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = I18n.t "password_reset_expired"
        redirect_to new_password_reset_url
      end
    end
end
