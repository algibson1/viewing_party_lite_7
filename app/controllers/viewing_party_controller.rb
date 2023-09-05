class ViewingPartyController < ApplicationController
  before_action :find_user

  def new
    @movie = facade.find_movie(params[:movie_id])
  end

  def create
    # Do some error handling instead?
    party = ViewingParty.new(party_params)
    if party.save
      party.send_invites(params[:user_id], guest_hash)
      redirect_to user_path(@user)
      flash[:success] = 'Party Created Successfully'
    else
      redirect_to new_user_movie_viewing_party_path(@user, params[:movie_id])
      flash[:alert] = "Error: #{party.errors.full_messages.to_sentence}"
    end
  end

  private

  def find_user
    @user = User.find(params[:user_id])
  end

  def party_params
    params.permit(:duration, :party_date, :start_time, :movie_id)
  end

  def guest_hash
    params[:guests].permit!.to_h
  end
end
