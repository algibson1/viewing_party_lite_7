class MoviesController < ApplicationController
  
  def index
    @query = params[:query]
    @movies = facade.movies_list(@query)
  end

  def show
    @movie = facade.find_movie(params[:id])
  end

  private
  
  def facade
    @facade ||= MoviesFacade.new
  end
end