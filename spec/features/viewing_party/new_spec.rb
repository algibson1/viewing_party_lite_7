require 'rails_helper'

RSpec.describe 'New Viewing Party Page', :vcr do
  before do
    @ally = User.create!(name: 'Ally Jean', email: 'allyjean@example.com', password: 'password1', password_confirmation: 'password1')
    @jimmy = User.create!(name: 'Jimmy Jean', email: 'jimmyjean@example.com', password: 'password1', password_confirmation: 'password1')
    @bobby = User.create!(name: 'Bobby Jean', email: 'bobbyjean@example.com', password: 'password1', password_confirmation: 'password1')
    @dennis = User.create!(name: 'Dennis Jean', email: 'dennisjean@example.com', password: 'password1', password_confirmation: 'password1')
    @guests = [@jimmy, @bobby, @dennis]
    @movie = MoviesFacade.new.find_movie(234)
    log_in(@ally, 'password1')
    visit new_movie_viewing_party_path(@movie.id)
  end

  it 'has fields: duration, date, start time, checkboxes to invite users, and a submit button' do
    expect(page).to have_content("Create A Movie Party for #{@movie.title}")
    expect(page).to have_content('Viewing Party Details')
    expect(page).to have_content('Movie Title')
    expect(page).to have_content(@movie.title, count: 2)
    expect(page).to have_content('Duration of party')
    expect(page).to have_field(:duration, with: @movie.runtime)
    expect(page).to have_content('Day')
    expect(page).to have_field(:party_date, with: Date.today)
    expect(page).to have_content('Start time')
    expect(page).to have_field(:start_time, with: Time.now.strftime("%H:%M"))
    expect(page).to have_button('Create Party')
  end

  it 'creates a new viewing party' do
    click_button('Create Party')
    expect(current_path).to eq(dashboard_path)
    expect(page).to have_content(@movie.title)
    expect(page).to have_content('Hosting')
    expect(page).to have_content('Party Created Successfully')
    party = ViewingParty.last
    expect(party.duration).to eq(78)
    expect(party.movie_id).to eq(234)
    expect(party.host).to eq(@ally)
  end

  it 'has checkboxes to invite users' do
    expect(page).to have_content('Invite Other Users')
    @guests.each do |guest|
      expect(page).to have_content("#{guest.name} (#{guest.email})")
      expect(page).to have_field("_guests_#{guest.id}")
    end
  end

  it 'cannot be set with a duration less than movie runtime' do
    fill_in(:duration, with: 77)
    click_button('Create Party')
    expect(page).to have_content('Error: Duration must be greater than or equal to 78')
  end

  it 'cannot be set to a date earlier than current date' do
    fill_in(:party_date, with: (Date.today - 1))
    click_button('Create Party')
    expect(page).to have_content('Error: Party date cannot be in the past')
  end

  it 'cannot be set to a time earlier than current time' do
    fill_in(:start_time, with: (Time.now - 1.hours).strftime('%H:%M'))
    click_button('Create Party')
    expect(page).to have_content('Error: Start time cannot be in the past')
  end

  it 'can be set to a time earlier than current time, if date is in the future' do
    fill_in(:party_date, with: (Date.today + 1))
    fill_in(:start_time, with: (Time.now - 1.hours).strftime('%H:%M'))
    click_button('Create Party')
    expect(current_path).to eq(dashboard_path)
    expect(page).to have_content('Party Created Successfully')
  end

  it 'will show this party on the dashboard pages of invited users' do
    log_in(@jimmy, 'password1')
    visit dashboard_path

    expect(page).to_not have_content(@movie.title)

    log_in(@ally, 'password1')
    visit new_movie_viewing_party_path(@movie.id)
    check("_guests_#{@jimmy.id}")
    check("_guests_#{@bobby.id}")
    click_button('Create Party')

    expect(page).to have_content(@movie.title)
    expect(page).to have_content('Hosting')

    log_in(@jimmy, 'password1')
    visit dashboard_path
    expect(page).to have_content(@movie.title)
    expect(page).to have_content('Invited')

    log_in(@bobby, 'password1')
    visit dashboard_path
    expect(page).to have_content(@movie.title)
    expect(page).to have_content('Invited')

    log_in(@dennis, 'password1')
    visit dashboard_path
    expect(page).to_not have_content('Invited')
    expect(page).to_not have_content(@movie.title)
  end

  it 'has a link to return to discover page' do
    expect(page).to have_link('Discover Movies')
    click_link('Discover Movies')
    expect(current_path).to eq(discover_path)
  end
end
