class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def register
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = 'Successfully registered.'
      redirect_to user_path(@user)
    else
      flash[:error] = @user.errors.full_messages.to_sentence
      redirect_to register_path
    end
  end

  def login_form
    @user = User.find(params[:user_id]) if params[:user_id].present?
  end
  
  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      flash[:success] = "Welcome, #{user.name}!"
      redirect_to user_path(user)
    else 
      flash[:error] = "Sorry, those credentials are invalid"
      render :login_form
    end
  end

  def discover
    @user = User.find(params[:user_id])
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
