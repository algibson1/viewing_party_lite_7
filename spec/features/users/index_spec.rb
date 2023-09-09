require 'rails_helper'

RSpec.describe 'User index page' do
  context 'whether or not a user is logged in' do
    it 'displays a title' do
      visit(root_path)
      expect(page).to have_content('Viewing Party Lite')
    end

    it 'displays a link to go back to the landing page' do
      visit(root_path)
      expect(page).to have_link('Home', href: root_path)
    end
  end

  context 'when no users are logged in' do
    it 'displays a button to create a new user' do
      visit root_path
      expect(page).to have_link('Create New User', href: register_path)
    end

    it 'displays a button to log in' do
      visit root_path

      expect(page).to have_link('Log In', href: login_path)
    end

    it 'has no user data' do
      @user1 = User.create!(name: 'user1', email: 'user1@turing.edu', password: 'password1', password_confirmation: 'password1')
      @user2 = User.create!(name: 'user2', email: 'user2@turing.edu', password: 'password2', password_confirmation: 'password2')
      @user3 = User.create(name: 'user3', email: 'user3@turing.edu', password: 'password3', password_confirmation: 'password3')
      visit root_path

      expect(page).to_not have_content(@user1.name)
      expect(page).to_not have_content(@user1.email)
      expect(page).to_not have_content(@user2.name)
      expect(page).to_not have_content(@user2.email)
      expect(page).to_not have_content(@user3.name)
      expect(page).to_not have_content(@user3.email)
    end

    it 'does not have a link to user dashboard' do
      visit root_path
      expect(page).to_not have_link('Dashboard')
    end

    it 'displays an error message if user tries to manually navigate to dashboard' do
      visit dashboard_path
      expect(current_path).to eq(root_path)
      expect(page).to have_content('Please log in or register to access your dashboard')
    end
  end

  context 'when a user is logged in' do
    before(:each) do
      ally = User.create!(name: 'Ally Jean', email: 'allyjean@example.com', password: 'password1', password_confirmation: 'password1')
      log_in(ally, 'password1')
      visit root_path
    end

    it 'displays a list of existing users' do
      @user1 = User.create!(name: 'user1', email: 'user1@turing.edu', password: 'password1', password_confirmation: 'password1')
      @user2 = User.create!(name: 'user2', email: 'user2@turing.edu', password: 'password2', password_confirmation: 'password2')
      @user3 = User.create(name: 'user3', email: 'user3@turing.edu', password: 'password3', password_confirmation: 'password3')
      visit root_path
      
      expect(page).to have_content(@user1.name)
      expect(page).to have_content(@user1.email)
      expect(page).to have_content(@user2.name)
      expect(page).to have_content(@user2.email)
      expect(page).to have_content(@user3.name)
      expect(page).to have_content(@user3.email)
    end

    it 'does not have Log In or Create New User buttons' do
      expect(page).to_not have_content('Create New User')
      expect(page).to_not have_content('Log In')
    end

    it 'has a log out button' do
      expect(page).to have_link('Log Out')
      click_link('Log Out')
      expect(current_path).to eq(root_path)
      expect(page).to have_link('Log In')
      expect(page).to_not have_content('Log Out')
    end

    it 'has a link to user dashboard' do
      expect(page).to have_link('Dashboard', href: dashboard_path)
    end
  end
end
