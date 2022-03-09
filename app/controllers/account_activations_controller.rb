class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = t ".activate_succeeded"
      redirect_to user
    else
      flash[:danger] = t ".activate_failed"
      redirect_to root_url
    end
  end
end
