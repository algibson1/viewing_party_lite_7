def load_test_data
  # Create Users
  @user1 = User.create!(name: 'user1', email: 'user1@turing.edu', password: 'password1', password_confirmation: 'password1')
  @user2 = User.create!(name: 'user2', email: 'user2@turing.edu', password: 'password2', password_confirmation: 'password2')
  @user3 = User.create(name: 'user3', email: 'user3@turing.edu', password: 'password3', password_confirmation: 'password3')

  # Create viewing parties

  @party1 = ViewingParty.create!(duration: 160, party_date: '2023-09-15', start_time: '19:00:00', movie_id: 13)
  @party2 = ViewingParty.create!(duration: 170, party_date: '2023-09-10', start_time: '20:00:00', movie_id: 155)

  # Assign hosts and guests to parties
  # user1 is the host of party1
  PartyGuest.create!(user: @user1, viewing_party: @party1, host: true)
  # user2 and user3 are guests of party1
  PartyGuest.create!(user: @user2, viewing_party: @party1, host: false)
  PartyGuest.create!(user: @user3, viewing_party: @party1, host: false)

  # user3 is the host of party2
  PartyGuest.create!(user: @user3, viewing_party: @party2, host: true)
  # user1 and user2 are guests of party2
  PartyGuest.create!(user: @user1, viewing_party: @party2, host: false)
  PartyGuest.create!(user: @user2, viewing_party: @party2, host: false)
end

def log_in(user, password)
  visit login_path

  fill_in('Email', with: user.email)
  fill_in('Password', with: password)
  click_button('Log In')
end