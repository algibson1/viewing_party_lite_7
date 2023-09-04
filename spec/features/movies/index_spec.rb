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
    xit 'shows the search results' do
      # VCR.use_cassette('search_results') do
        visit user_discover_path(@user1)
        fill_in :q, with: 'The Matrix'
        click_button 'Search'
        expect(current_path).to eq(user_movies_path(@user1))
        expect(page).to have_content('Search Results for \'The Matrix\'')
        # Checks that there are 20 results or less
        expect(all('tbody tr').count).to be <= 20
        # Checks that the wrong page title isn't shown
        within('.title-header') do
          expect(page).not_to have_content('Top Rated Movies')
        end
        # Iterates through each row in the table to ensure they all have a title and a vote average
        all('tbody tr').each do |row|
          within(row) do
            td_elements = all('td')
            expect(td_elements[0].text).not_to be_empty
            expect(td_elements[1].text).not_to be_empty
          end
        end
        expect(page).to have_link('Discover Page', href: user_discover_path(@user1))
      # end
    end

    xit 'has a link to home' do
      # VCR.use_cassette('search_results') do
        visit user_movies_path(@user1)
        expect(page).to have_link('Home', href: root_path)
        click_link 'Home'
        expect(current_path).to eq(root_path)
      # end
    end

    xit 'has a link to discover' do
      # VCR.use_cassette('search_results') do
        visit user_movies_path(@user1)
        expect(page).to have_link('Discover Page', href: user_discover_path(@user1))
        click_link 'Discover Page'
        expect(current_path).to eq(user_discover_path(@user1))
      # end
    end

    xit 'has a link to the movie show view' do
      # VCR.use_cassette('search_results') do
        visit user_discover_path(@user1)
        fill_in :q, with: 'The Matrix'
        click_button 'Search'
        expect(current_path).to eq(user_movies_path(@user1))
        expect(page).to have_link('The Matrix')
        click_link 'The Matrix'
        expect(current_path).to eq(user_movie_show_path(@user1, 603))
      # end
    end
  end
end
