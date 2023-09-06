# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

# Destroy existing records
PartyGuest.destroy_all
ViewingParty.destroy_all
User.destroy_all

# Create users
alice = User.create!(name: 'Alice', email: 'alice@example.com', password: 'password1', password_confirmation: 'password1')
bob = User.create!(name: 'Bob', email: 'bob@example.com', password: 'password2', password_confirmation: 'password2')
carol = User.create!(name: 'Carol', email: 'carol@example.com', password: 'password3', password_confirmation: 'password3')

# Create viewing parties
party1 = ViewingParty.create!(duration: 150, party_date: '2023-09-15', start_time: '19:00:00', movie_id: 13)
party2 = ViewingParty.create!(duration: 160, party_date: '2023-09-10', start_time: '20:00:00', movie_id: 155)

# Assign hosts and guests to parties
# Alice is the host of party1
PartyGuest.create!(user: alice, viewing_party: party1, host: true)
# Bob and Carol are guests of party1
PartyGuest.create!(user: bob, viewing_party: party1, host: false)
PartyGuest.create!(user: carol, viewing_party: party1, host: false)

# Carol is the host of party2
PartyGuest.create!(user: carol, viewing_party: party2, host: true)
# Alice and Bob are guests of party2
PartyGuest.create!(user: alice, viewing_party: party2, host: false)
PartyGuest.create!(user: bob, viewing_party: party2, host: false)
