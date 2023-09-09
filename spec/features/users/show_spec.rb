require 'rails_helper'

RSpec.describe 'User dashboard', :vcr do
  before do
    load_test_data
    log_in(@user1, 'password1')
    visit dashboard_path
  end

  it 'has a heading' do
    expect(page).to have_content("user1's Dashboard")
  end

  it 'has a button to discover movies' do
    expect(page).to have_link('Discover Movies')
    click_link('Discover Movies')
    expect(current_path).to eq(discover_path)
  end

  it 'displays a list of parties the user is invited to' do
    visit dashboard_path
    expect(page).to have_content('My Parties')
    expect(page).to have_content("Parties I'm Invited To")

    within('#invited-parties') do
      expect(page).to have_selector('img')
      expect(page).to have_content(@party2.movie_title)
      expect(page).to_not have_content(@party1.movie_title)
      expect(page).to have_content(@party2.party_date)
      expect(page).to have_content(@party2.start_time.strftime('%I:%M %p'))
      
      host_name_td = find("#host-name-td-#{@party2.id}")
      expect(host_name_td).to have_content(@user3.name)
      
      within("#guest-list-td-#{@party2.id}") do
        expect(page).to_not have_content(@user3.name)
        expect(page).to have_content(@user1.name)
        expect(page).to have_content(@user2.name)
      end
    end
  end

  it 'displays a list of parties the user is hosting' do
    visit dashboard_path
    expect(page).to have_content('My Parties')
    expect(page).to have_content("Parties I'm Hosting")

    within('#hosted-parties') do
      expect(page).to have_selector('img')
      expect(page).to have_content(@party1.movie_title)
      expect(page).to_not have_content(@party2.movie_title)
      expect(page).to have_content(@party1.party_date)
      expect(page).to have_content(@party1.start_time.strftime('%I:%M %p'))
      
      host_name_td = find("#host-name-td-#{@party1.id}")
      expect(host_name_td).to have_content(@user1.name)
      
      within("#guest-list-td-#{@party1.id}") do
        expect(page).to have_content(@user3.name)
        expect(page).to_not have_content(@user1.name)
        expect(page).to have_content(@user2.name)
      end
    end
  end

  it 'has a link to the movie show page' do
    movie = @party1.movie
    visit dashboard_path
    expect(page).to have_link(movie.title)
    click_link movie.title
    expect(current_path).to eq(movie_path(movie.id))
  end
end