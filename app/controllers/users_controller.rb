class UsersController < ApplicationController
  def index; end

  def show
    @user = User.find params[:id]
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = t ".not_found"
    redirect_to root_path
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:success] = t ".create_succeeded"
      redirect_to @user
    else
      flash[:danger] = t ".create_failed"
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end
end
