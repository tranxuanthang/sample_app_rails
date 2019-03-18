class ApplicationController < ActionController::Base
  include SessionsHelper

  private
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = I18n.t "please_login"
        redirect_to login_url
      end
    end
end
