require 'rails_helper'

RSpec.describe MoviesService, :vcr do
  it 'can retrieve top 20 movies' do
    response = MoviesService.new.top_rated
    expect(response).to be_a(Faraday::Response)
    expect(response.env[:url].to_s).to include("top_rated")

    movies = JSON.parse(response.body, symbolize_names: true)
    expect(movies[:results].count).to eq(20)
  end

  it 'can search for movies by keyword in title' do
    response = MoviesService.new.search('inception')

    expect(response).to be_an(Faraday::Response)

    movies = JSON.parse(response.body, symbolize_names: true)[:results]
    expect(movies.first).to have_key(:title)

    titles = movies.map { |movie| movie[:title].downcase }
    expect(titles.all? { |title| title.include?('inception') }).to be(true)
  end

  it 'can search for a single movie by ID' do
    response = MoviesService.new.find_movie(234)
    expect(response).to be_a(Faraday::Response)
    
    movie = JSON.parse(response.body, symbolize_names: true)

    expect(movie).to be_a(Hash)
    expect(movie).to have_key(:title)
    expect(movie).to have_key(:reviews)
    expect(movie).to have_key(:credits)
  end
end
