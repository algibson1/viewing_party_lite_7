require 'rails_helper'

RSpec.describe 'Movies Index Page (Discover Movies)', :vcr do
  context 'when no query has been provided' do
    it 'can link to the find top rated movies page' do
      visit discover_path
      expect(page).to have_button('Find Top Rated Movies')
      click_button('Find Top Rated Movies')
      expect(current_path).to eq(movies_path)
      expect(page).to have_content("Top Rated Movies")
    end
  
    it 'can link to the find movies by keyword page' do
      visit discover_path
      expect(page).to have_field('Find Movies')
      expect(page).to have_button('Search')
      fill_in 'Find Movies', with: 'Inception'
      click_button('Search')
      expect(current_path).to eq(movies_path)
      expect(page).to have_content("Search Results for 'Inception'")
    end
  end

  context 'when top rated movies is selected' do
    it 'shows the top rated movies' do
      visit discover_path
      click_button 'Find Top Rated Movies'
      expect(current_path).to eq(movies_path)
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
      expect(page).to have_link('Discover Movies', href: discover_path)
      expect(page).to have_link('Home', href: root_path)
    end

    it 'has a link to home' do
      visit movies_path
      expect(page).to have_link('Home', href: root_path)
      click_link 'Home'
      expect(current_path).to eq(root_path)
    end

    it 'has a link to the movie show view' do
      visit discover_path
      click_button 'Find Top Rated Movies'
      expect(current_path).to eq(movies_path)
      expect(page).to have_link('The Godfather')
      click_link 'The Godfather'
      expect(current_path).to eq(movie_path(238))
    end
  end

  context 'when user searches movies by keyword' do
    it 'shows movies with titles that contain the keyword' do
      visit discover_path
      fill_in :query, with: 'The Matrix'
      click_button 'Search'
      expect(current_path).to eq(movies_path)
      
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

      expect(page).to have_link('Discover Movies', href: discover_path)
      expect(page).to have_link('Home', href: root_path)
    end

    it 'has a link to the movie show view' do
      visit discover_path
      fill_in :query, with: 'The Matrix'
      click_button 'Search'
      expect(current_path).to eq(movies_path)
      expect(page).to have_link('The Matrix')
      click_link 'The Matrix'
      expect(current_path).to eq(movie_path(603))
    end
  end
end
