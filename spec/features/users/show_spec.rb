require 'rails_helper'

RSpec.describe 'User dashboard', :vcr do
  before do
    load_test_data
  end

  it 'has a heading' do
    ally = User.create!(name: 'Ally Jean', email: 'allyjean@example.com')
    visit user_path(ally)
    expect(page).to have_content("Ally Jean's Dashboard")
  end

  it 'has a button to discover movies' do
    visit user_path(@user1)
    expect(page).to have_button('Discover Movies')
  end

  it 'displays a list of parties the user is invited to' do
    movie = MoviesFacade.new.find_movie(155)
    visit user_path(@user1)
    expect(page).to have_content('My Parties')
    expect(page).to have_content("Parties I'm Invited To")

    within('#invited-parties') do
      expect(page).to have_content('The Dark Knight')
      expect(page).to have_selector('img')
      expect(page).to have_content(movie.title)
      expect(page).to have_content(@party2.party_date)
      expect(page).to have_content(@party2.start_time.strftime('%I:%M %p'))
      
      host_name_td = find("#host-name-td-#{@party2.id}")
      expect(host_name_td).to have_content(@user3.name)
      
      expect(page).to have_content(@user3.name)
      expect(page).to have_content(@user1.name)
      expect(page).to have_content(@user2.name)
    end
  end

  it 'displays a list of parties the user is hosting' do
    movie = MoviesFacade.new.find_movie(13)
    visit user_path(@user1)
    expect(page).to have_content('My Parties')
    expect(page).to have_content("Parties I'm Hosting")

    within('#hosted-parties') do
      expect(page).to have_content('Forrest Gump')
      expect(page).to have_selector('img')
      expect(page).to have_content(movie.title)
      expect(page).to have_content(@party1.party_date)
      expect(page).to have_content(@party1.start_time.strftime('%I:%M %p'))
      
      host_name_td = find("#host-name-td-#{@party1.id}")
      expect(host_name_td).to have_content(@user1.name)
      
      expect(page).to have_content(@user3.name)
      expect(page).to have_content(@user1.name)
      expect(page).to have_content(@user2.name)
    end
  end

  it 'has a link to the movie show page' do
    movie = MoviesFacade.new.find_movie(13)
    visit user_path(@user1)
    expect(page).to have_link(movie.title)
    click_link movie.title
    expect(current_path).to eq(user_movie_path(@user1, movie.id))
  end
end