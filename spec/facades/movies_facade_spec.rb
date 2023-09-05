require 'rails_helper'

RSpec.describe MoviesFacade, :vcr do
  it 'has no movies by default' do
    facade = MoviesFacade.new
    expect(facade._cached_movies).to be_empty
  end

  it 'can collect and save movies' do
    facade = MoviesFacade.new
    movie1 = facade.find_movie(234)
    expect(facade._cached_movies).to eq({ 234 => movie1 })
    movie1_renamed = facade.find_movie(234)
    movie2 = facade.find_movie(550)
    movie2_renamed = facade.find_movie(550)
    expect(movie1).to eq(movie1_renamed)
    expect(movie2).to eq(movie2_renamed)
    expect(facade._cached_movies).to eq({ 234 => movie1, 550 => movie2 })
  end

  it 'can return a list of top_rated movies' do
    facade = MoviesFacade.new
    top_movies = facade.movies_list('top_rated')
    expect(top_movies).to be_an(Array)
    expect(top_movies).to all be_a(Movie)
    expect(top_movies.count).to eq(20)
    
    expect(top_movies.all? { |movie| movie.rating > 8}).to eq(true)
  end

  it 'can search for movies by a query term' do
    facade = MoviesFacade.new
    movies = facade.movies_list('Inception')
    expect(movies).to be_an(Array)
    expect(movies).to all be_a(Movie)
    expect(movies.count <= 20).to eq(true)
    
    expect(movies.all? { |movie| movie.title.include?('Inception')}).to eq(true)
  end
end
