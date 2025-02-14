require 'rails_helper'

RSpec.describe ViewingParty, :vcr do
  describe 'validations' do
    it { should have_many :party_guests }
    it { should have_many(:users).through(:party_guests) }
    it { should validate_presence_of :movie_id }
    it { should validate_presence_of :duration }
    it { should validate_numericality_of :duration }
    it { should validate_presence_of :party_date } 
    it { should validate_presence_of :start_time }
    
    it 'validates duration has a minimum value of the movie runtime' do
      User.create!(name: 'Ally Jean', email: 'allyjean@example.com', password: 'password1', password_confirmation: 'password1')

      expect(ViewingParty.create(movie_id: 234, duration: 77, party_date: Date.today, start_time: Time.now.strftime("%H:%M"))).to_not be_valid
      expect(ViewingParty.create(movie_id: 234, duration: 78, party_date: Date.today, start_time: Time.now.strftime("%H:%M"))).to be_valid
    end

    it 'validates that party date is on or after today' do
      User.create!(name: 'Ally Jean', email: 'allyjean@example.com', password: 'password1', password_confirmation: 'password1')

      expect(ViewingParty.create(movie_id: 234, duration: 200, party_date: (Date.today - 1), start_time: Time.now.strftime("%H:%M"))).to_not be_valid
      expect(ViewingParty.create(movie_id: 234, duration: 200, party_date: Date.today, start_time: Time.now.strftime("%H:%M"))).to be_valid
    end

    it "validates that start time is not in the past" do
      User.create!(name: 'Ally Jean', email: 'allyjean@example.com', password: 'password1', password_confirmation: 'password1')

      expect(ViewingParty.create(movie_id: 234, duration: 200, party_date: Date.today, start_time: (Time.now - 1.hours).strftime("%H:%M"))).to_not be_valid
      expect(ViewingParty.create(movie_id: 234, duration: 78, party_date: Date.today, start_time: Time.now.strftime("%H:%M"))).to be_valid
      expect(ViewingParty.create(movie_id: 234, duration: 78, party_date: (Date.today + 2), start_time: (Time.now - 1.hours).strftime("%H:%M"))).to be_valid
    end
  end

  it 'has a movie' do
    party = ViewingParty.create!(movie_id: 234, duration: 78, party_date: Date.today, start_time: Time.now.strftime("%H:%M"))
    expect(party.movie).to be_a(Movie)
  end

  it 'can report movie duration' do
    party = ViewingParty.create!(movie_id: 234, duration: 78, party_date: Date.today, start_time: Time.now.strftime("%H:%M"))
    expect(party.movie_duration).to eq(78)
  end

  it 'has a movie image' do
    movie = MoviesFacade.new.find_movie(234)
    party = ViewingParty.create!(movie_id: 234, duration: 78, party_date: Date.today, start_time: Time.now.strftime("%H:%M"))
    expect(party.movie_image.end_with?(movie.image)).to eq(true)
  end

  it 'has a movie title' do
    movie = MoviesFacade.new.find_movie(234)
    party = ViewingParty.create!(movie_id: 234, duration: 78, party_date: Date.today, start_time: Time.now.strftime("%H:%M"))
    expect(party.movie_title).to eq(movie.title)
  end

  it 'can send invites' do
    party = ViewingParty.create!(movie_id: 234, duration: 78, party_date: Date.today, start_time: Time.now.strftime("%H:%M"))
    ally = User.create!(name: 'Ally Jean', email: 'allyjean@example.com', password: 'password1', password_confirmation: 'password1')
    jimmy = User.create!(name: 'Jimmy Jean', email: 'jimmyjean@example.com', password: 'password1', password_confirmation: 'password1')
    bobby = User.create!(name: 'Bobby Jean', email: 'bobbyjean@example.com', password: 'password1', password_confirmation: 'password1')
    dennis = User.create!(name: 'Dennis Jean', email: 'dennisjean@example.com', password: 'password1', password_confirmation: 'password1')

    expect(party.users).to eq([])

    party.send_invites(ally.id, { jimmy.id.to_s => '1', bobby.id.to_s => '1', dennis.id.to_s => '0' })

    expect(party.users).to match_array([ally, jimmy, bobby])
    expect(party.users).to_not include(dennis)
  end

  it 'can report the host' do
    party = ViewingParty.create!(movie_id: 234, duration: 78, party_date: Date.today, start_time: Time.now.strftime("%H:%M"))
    ally = User.create!(name: 'Ally Jean', email: 'allyjean@example.com', password: 'password1', password_confirmation: 'password1')
    jimmy = User.create!(name: 'Jimmy Jean', email: 'jimmyjean@example.com', password: 'password1', password_confirmation: 'password1')
    bobby = User.create!(name: 'Bobby Jean', email: 'bobbyjean@example.com', password: 'password1', password_confirmation: 'password1')
    dennis = User.create!(name: 'Dennis Jean', email: 'dennisjean@example.com', password: 'password1', password_confirmation: 'password1')

    expect(party.users).to eq([])
    party.send_invites(ally.id, { jimmy.id.to_s => '1', bobby.id.to_s => '1', dennis.id.to_s => '0' })
    expect(party.host).to eq(ally)
  end

  it 'can report all invitees' do 
    party = ViewingParty.create!(movie_id: 234, duration: 78, party_date: Date.today, start_time: Time.now.strftime("%H:%M"))
    ally = User.create!(name: 'Ally Jean', email: 'allyjean@example.com', password: 'password1', password_confirmation: 'password1')
    jimmy = User.create!(name: 'Jimmy Jean', email: 'jimmyjean@example.com', password: 'password1', password_confirmation: 'password1')
    bobby = User.create!(name: 'Bobby Jean', email: 'bobbyjean@example.com', password: 'password1', password_confirmation: 'password1')
    dennis = User.create!(name: 'Dennis Jean', email: 'dennisjean@example.com', password: 'password1', password_confirmation: 'password1')

    expect(party.users).to eq([])
    party.send_invites(ally.id, { jimmy.id.to_s => '1', bobby.id.to_s => '1', dennis.id.to_s => '0' })
    expect(party.invitees).to eq([jimmy, bobby])
  end

  it 'can list invitees by name' do
    party = ViewingParty.create!(movie_id: 234, duration: 78, party_date: Date.today, start_time: Time.now.strftime("%H:%M"))
    ally = User.create!(name: 'Ally Jean', email: 'allyjean@example.com', password: 'password1', password_confirmation: 'password1')
    jimmy = User.create!(name: 'Jimmy Jean', email: 'jimmyjean@example.com', password: 'password1', password_confirmation: 'password1')
    bobby = User.create!(name: 'Bobby Jean', email: 'bobbyjean@example.com', password: 'password1', password_confirmation: 'password1')
    dennis = User.create!(name: 'Dennis Jean', email: 'dennisjean@example.com', password: 'password1', password_confirmation: 'password1')

    expect(party.users).to eq([])
    party.send_invites(ally.id, { jimmy.id.to_s => '1', bobby.id.to_s => '1', dennis.id.to_s => '0' })
    expect(party.invitee_names).to eq(["Jimmy Jean", "Bobby Jean"])
  end
end
