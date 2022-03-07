class SessionsController < ApplicationController
  def new; end

  def create
    email, password = params[:session].values_at :email, :password

    user = User.find_by email: email.downcase
    if user&.authenticate password
      log_in user
      redirect_to user
    else
      flash.now[:danger] = t ".error.bad_credentials"
      render :new
    end
  end

  def destroy
    log_out
    flash[:info] = t ".info.logout_msg"
    redirect_to root_url
  end
end
