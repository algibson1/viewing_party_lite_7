class UsersController < ApplicationController
  def index
    @user = User.find(session[:user_id]) if session[:user_id]
  end

  def show
    begin
      @user = User.find(session[:user_id])
    rescue
      redirect_to root_path
      flash[:alert] = "Please log in or register to access your dashboard"
    end
  end

  def new
    @user = User.new
  end

  def create
    new_user = User.new(user_params)
    if new_user.save
      session[:user_id] = new_user.id 
      flash[:success] = 'Successfully registered.'
      redirect_to dashboard_path
    else
      flash[:error] = new_user.errors.full_messages.to_sentence
      redirect_to register_path
    end
  end

  def login_form
    @user = User.find(params[:user_id]) if params[:user_id].present?
  end
  
  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      session[:user_id] = user.id # Add to a SessionsController as Index after refactoring?
      flash[:success] = "Welcome, #{user.name}!"
      redirect_to dashboard_path
    else 
      flash[:error] = "Sorry, those credentials are invalid"
      render :login_form
    end
  end

  def logout
    session.clear
    redirect_to root_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
