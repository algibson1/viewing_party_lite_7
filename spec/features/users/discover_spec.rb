require 'rails_helper'

RSpec.describe 'User Discover Movies Page', :vcr do
  before do
    @ally = User.create(name: 'user', email: 'test@example.com')

    json_response = File.read('spec/fixtures/top_rated_movies_sample.json')
    stub_request(:get, 'https://api.themoviedb.org/3/movie/top_rated')
      .with(
        query: {
          'api_key' => Rails.application.credentials.tmdb_movies[:key]
        }
      )
      .to_return(status: 200, body: json_response)
    allow_any_instance_of(MoviesService).to receive(:top_rated).and_return(JSON.parse(json_response,
                                                                                      symbolize_names: true)[:results])
  end

  it 'links from the user dashboard' do
    visit user_path(@ally)

    click_button('Discover Movies')
    expect(current_path).to eq(user_discover_path(@ally))

    expect(page).to have_content('Discover Movies')
  end

  it 'can link to the find top rated movies page' do
    visit user_discover_path(@ally)
    expect(page).to have_button('Find Top Rated Movies')
    click_button('Find Top Rated Movies')
    expect(current_path).to eq(user_movies_path(@ally))
  end

  it 'can link to the find movies by keyword page' do
    visit user_discover_path(@ally)
    expect(page).to have_field('Find Movies')
    expect(page).to have_button('Search')
    fill_in 'Find Movies', with: 'Inception'
    click_button('Search')
    expect(current_path).to eq(user_movies_path(@ally))
  end
end
