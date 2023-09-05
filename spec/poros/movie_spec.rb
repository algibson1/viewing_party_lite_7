require 'rails_helper'

RSpec.describe Movie do
  before do
    json_response = File.read('spec/fixtures/movie_sample.json')
    stub_request(:get, 'https://api.themoviedb.org/')
      .with(
        query: {
          'api_key' => Rails.application.credentials.tmdb_movies[:key],
          'append_to_response' => 'reviews,credits'
        }
      )
      .to_return(status: 200, body: json_response)

    @parsed = JSON.parse(json_response, symbolize_names: true)
    @movie = Movie.new(@parsed)
  end

  it 'has an id' do
    expect(@movie.id).to eq(234)
    expect(@movie.id).to be_an(Integer)
  end

  it 'has an image' do
    expect(@movie.image).to be_a(String)
    expect(@movie.image.end_with?('.jpg')).to eq(true)
  end

  it 'has a title' do
    expect(@movie.title).to be_a(String)
    expect(@movie.title).to eq('The Cabinet of Dr. Caligari')
  end

  it 'has a rating' do
    expect(@movie.rating).to be_a(Float)
    expect(@movie.rating).to eq(7.955)
  end

  it 'has a runtime' do
    expect(@movie.runtime).to be_an(Integer)
    expect(@movie.runtime).to eq(78)
  end

  it 'can format runtime' do
    expect(@movie.format_runtime).to be_a(String)
    expect(@movie.format_runtime).to eq('1hr 18min')
  end

  it 'can format genres' do
    result = @movie.format_genres([
      { id: 18, name: 'Drama' }, 
      { id: 27, name: 'Horror' },
      { id: 53, name: 'Thriller' }, 
      { id: 80, name: 'Crime' }
      ])
    expect(result).to eq('Drama, Horror, Thriller, Crime')
  end

  it 'has genres' do
    expect(@movie.genres).to be_a(String)
    expect(@movie.genres).to eq('Drama, Horror, Thriller, Crime')
  end

  it 'has a summary' do
    expect(@movie.summary).to be_a(String)
    expect(@movie.summary).to eq('Francis, a young man, recalls in his memory the horrible experiences he and his fiancée Jane recently went through. Francis and his friend Alan visit The Cabinet of Dr. Caligari, an exhibit where the mysterious doctor shows the somnambulist Cesare, and awakens him for some moments from his death-like sleep.')
  end

  it 'formats cast members into an array with maximum 10' do
    result = @movie.generate_cast(@parsed[:credits][:cast])

    expect(result).to be_an(Array)
    expect(result).to all be_a(CastMember)
    expect(result.count).to eq(10)
  end

  it 'has an array of ten cast members' do
    expect(@movie.cast).to be_an(Array)
    expect(@movie.cast.count).to eq(10)
    expect(@movie.cast).to all be_a(CastMember)
  end

  it 'can count total reviews' do
    expect(@movie.total_reviews).to be_an(Integer)
    expect(@movie.total_reviews).to eq(2)
  end

  it 'can format reviews' do
    result = @movie.generate_reviews(@parsed[:reviews][:results])

    expect(result).to be_an(Array)
    expect(result.count).to eq(@movie.total_reviews)
    expect(result).to all be_a(Review)
  end

  it 'has reviews' do
    expect(@movie.reviews).to be_an(Array)
    expect(@movie.reviews.count).to eq(@movie.total_reviews)
    expect(@movie.reviews).to all be_a(Review)
  end
end
