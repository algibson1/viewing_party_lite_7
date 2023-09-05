class MoviesController < ApplicationController
  before_action :find_user, only: [:index, :show]
  
  def index
    @query = params[:query]
    @movies = facade.movies_list(@query)
  end

  def show
    @movie = facade.find_movie(params[:id])
  end

  private
  def find_user
    @user = User.find(params[:user_id])
  end

  def facade
    @facade ||= MoviesFacade.new
  end
end