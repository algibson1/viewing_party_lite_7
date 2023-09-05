require 'rails_helper'

# RSpec.describe 'Discover Movies Page' do
RSpec.describe 'Movies Index Page', :vcr do
  before :each do
    load_test_data
  end

  context 'when top rated movies is selected' do
    it 'shows the top rated movies' do
      visit user_discover_path(@user1)
      click_button 'Find Top Rated Movies'
      expect(current_path).to eq(user_movies_path(@user1))
      expect(page).to have_content('Top Rated Movies')
      
      expect(all('tbody tr').count).to eq(20)
      
      within('.title-header') do
        expect(page).not_to have_content('Search Results')
      end
      
      all('tbody tr').each do |row|
        within(row) do
          td_elements = all('td')
          expect(td_elements[0].text).not_to be_empty
          expect(td_elements[1].text).not_to be_empty
        end
      end
      expect(page).to have_link('Discover Page', href: user_discover_path(@user1))
      expect(page).to have_link('Home', href: root_path)
    end

    it 'has a link to home' do
      visit user_movies_path(@user1)
      expect(page).to have_link('Home', href: root_path)
      click_link 'Home'
      expect(current_path).to eq(root_path)
    end

    it 'has a link to the movie show view' do
      visit user_discover_path(@user1)
      click_button 'Find Top Rated Movies'
      expect(current_path).to eq(user_movies_path(@user1))
      expect(page).to have_link('The Godfather')
      click_link 'The Godfather'
      expect(current_path).to eq(user_movie_path(@user1, 238))
    end
  end

  context 'when user searches movies by keyword' do
    it 'shows movies with titles that contain the keyword' do
      visit user_discover_path(@user1)
      fill_in :query, with: 'The Matrix'
      click_button 'Search'
      expect(current_path).to eq(user_movies_path(@user1))
      
      expect(all('tbody tr').count).to be <= 20
      
      within('.title-header') do
        expect(page).to have_content('Search Results for \'The Matrix\'')
      end

      expect(page).to have_content('The Matrix', minimum: 2)
      
      all('tbody tr').each do |row|
        within(row) do
          td_elements = all('td')
          expect(td_elements[0].text).not_to be_empty
          expect(td_elements[1].text).not_to be_empty
        end
      end

      expect(page).to have_link('Discover Page', href: user_discover_path(@user1))
      expect(page).to have_link('Home', href: root_path)
    end

    it 'has a link to the movie show view' do
      visit user_discover_path(@user1)
      fill_in :query, with: 'The Matrix'
      click_button 'Search'
      expect(current_path).to eq(user_movies_path(@user1))
      expect(page).to have_link('The Matrix')
      click_link 'The Matrix'
      expect(current_path).to eq(user_movie_path(@user1, 603))
    end
  end
end
