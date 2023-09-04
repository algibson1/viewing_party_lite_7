class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def show
    @user = User.includes(viewing_parties: :party_guests).find(params[:id])
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

  def discover
    @user = User.find(params[:user_id])
  end

  private

  def user_params
    params.require(:user).permit(:name, :email)
  end
end
