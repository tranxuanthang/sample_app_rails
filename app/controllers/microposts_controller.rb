class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build micropost_params
    if @micropost.save
      flash[:success] = I18n.t "micropost_created"
      redirect_to root_url
    else
      @feed_items = []
      render :"static_pages/home"
    end
  end

  def destroy
    @micropost.destroy
    if @micropost.destroyed?
      flash[:success] = I18n.t "micropost_deleted"
      redirect_to request.referrer || root_url
    else
      flash[:danger] = I18n.t "micropost_not_deleted"
      redirect_to request.referrer || root_url
    end
  end

  private
    def micropost_params
      params.require(:micropost).permit :content, :picture
    end

    def correct_user
      @micropost = current_user.microposts.find_by id: params[:id]
      return if @micropost
      flash[:danger] = I18n.t "micropost_not_found"
      redirect_to root_url
    end
end
