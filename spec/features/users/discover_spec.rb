require 'rails_helper'

RSpec.describe 'User Discover Movies Page', :vcr do
  before do
    @ally = User.create(name: 'user', email: 'test@example.com', password: 'password1', password_confirmation: 'password1')
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
