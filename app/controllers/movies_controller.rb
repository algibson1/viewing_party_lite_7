class MoviesController < ApplicationController
  before_action :find_user, only: [:index, :show]
  
  def index
    query = params[:query]

    movies_data = if query == 'top_rated'
                    MoviesService.new.top_rated
                  elsif query.present?
                    MoviesService.new.search(query)
                  else
                    []
                  end

    @movies = movies_data.map { |movie_data| Movie.new(movie_data) }
    @title = if query == 'top_rated'
               'Top Rated Movies'
             elsif query.present?
               "Search Results for '#{query}'"
             else
               'Error: No Query'
             end
    @movies = movies_data.map { |movie_data| Movie.new(movie_data) }
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