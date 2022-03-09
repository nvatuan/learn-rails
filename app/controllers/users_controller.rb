class UsersController < ApplicationController
  before_action :load_user, only: %i(show edit update destroy)
  before_action :logged_in_user, except: %i(show create new)
  before_action :correct_user, only: %i(edit update)
  before_action :is_admin?, only: :destroy

  def index
    @pagy, @users = pagy  User.activated,
                          items: Settings.paginate.items_per_page
  end

  def show
    redirect_to(root_url) && return unless @user.activated?
  end

  def edit; end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t ".activation_required"
      redirect_to root_url
    else
      flash.now[:danger] = t ".create_failed"
      render :new
    end
  end

  def update
    if @user.update user_params
      flash[:success] = t ".update_succeeded"
      redirect_to @user
    else
      flash.now[:danger] = t ".update_failed"
      render :edit
    end
  end

  def destroy
    flash[:success] = if @user.destroy
                        t ".delete_succeeded"
                      else
                        t ".delete_failed"
                      end
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation)
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "users.not_logged_in"
    redirect_to login_url
  end

  def correct_user
    @user = User.find params[:id]
    return if current_user? @user

    flash[:danger] = t "users.not_correct_user"
    redirect_to root_url
  end

  def is_admin?
    return if current_user.admin?

    flash[:danger] = t "users.unauthorized"
    redirect_to root_url
  end

  def load_user
    @user = User.find params[:id]
  rescue ActiveRecord::RecordNotFound
    flash[:danger] = t ".not_found"
    redirect_to root_path
  end
end
