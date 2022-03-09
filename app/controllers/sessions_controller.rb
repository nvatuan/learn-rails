class SessionsController < ApplicationController
  def new; end

  def create
    email, password, remember_me = params[:session].values_at :email,
                                                              :password,
                                                              :remember_me
    @user = User.find_by email: email.downcase
    return check_activate remember_me if @user&.authenticate password

    flash.now[:danger] = t ".error.bad_credentials"
    render :new
  end

  def destroy
    log_out if logged_in?
    flash[:info] = t ".info.logout_msg"
    redirect_to root_url
  end

  private

  def check_activate remember_me
    if @user.activated?
      log_in @user
      remember @user
      remember_me == "1" ? remember(@user) : forget(@user)
      redirect_back_or @user
    else
      flash[:warning] = t ".error.not_activated"
      redirect_to root_url
    end
  end
end
