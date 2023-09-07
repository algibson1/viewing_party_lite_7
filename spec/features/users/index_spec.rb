require 'rails_helper'

RSpec.describe 'User index page', :vcr do
  before :each do
    load_test_data
  end

  it 'displays a title' do
    visit(root_path)
    expect(page).to have_content('Viewing Party Lite')
  end

  it 'displays a button to create a new user' do
    visit(root_path)
    expect(page).to have_link('Create New User', href: register_path)
  end

  it 'displays a list of existing users' do
    visit(root_path)
    expect(page).to have_link(@user1.name)
    expect(page).to have_content(@user1.email)
    expect(page).to have_link(@user2.name)
    expect(page).to have_content(@user2.email)
  end

  it 'does not display a user with a duplicate email' do
    expect do
      User.create!(name: 'user3', email: 'user2@turing.edu', password: 'password1', password_confirmation: 'password1')
    end.to raise_error(ActiveRecord::RecordInvalid, 'Validation failed: Email has already been taken')

    expect do
      User.create(name: 'user3', email: 'user2@turing.edu', password: 'password1', password_confirmation: 'password1')
    end.to_not(change { User.count })
  end

  it 'displays a link to go back to the landing page' do
    visit(root_path)
    expect(page).to have_link('Home', href: root_path)
  end

  xit 'does not display Log In or Create Account links if user is logged in' do
#     As a logged in user 
# When I visit the landing page
# I no longer see a link to Log In or Create an Account
# But I see a link to Log Out.
# When I click the link to Log Out
# I'm taken to the landing page
# And I can see that the Log Out link has changed back to a Log In link

# Steps to consider
# Add a conditional in your view to show the correct Link (Remember, you can access session data in your views)
# Create a new route for logging out
# This action should remove the user_id from the session so that the user id doesn't persist.

  end

  xit '' do
#     As a visitor
# When I visit the landing page
# I do not see the section of the page that lists existing users
  end

  xit '' do
#     As a registered user
# When I visit the landing page
# The list of existing users is no longer a link to their show pages
# But just a list of email addresses
  end

  xit '' do 
#     As a visitor
# When I visit the landing page
# And then try to visit '/dashboard'
# I remain on the landing page
# And I see a message telling me that I must be logged in or registered to access my dashboard
  end

  xit '' do
    #add link to my dashboard from homepage as a registered user
    # Or all pages if user logged in?
  end

  xit '' do
    # add link to discover movies to all pages
  end

  xit '' do
    # change routes: dashboard and discover don't take user ids anymore 
  end

  xit '' do
    # (This will live in another file)
#     As a visitor
# If I go to a movies show page 
# And click the button to create a viewing party
# I'm redirected to the movies show page, and a message appears to let me know I must be logged in or registered to create a movie party. 
  end

  xit '' do
    #Extension for further practice
#     When I log in as an admin user
# I'm taken to my admin dashboard `/admin/dashboard`
# I see a list of all default user's email addresses
# When I click on a default user's email address
# I'm taken to the admin users dashboard. `/admin/users/:id`
# Where I see the same dashboard that particular user would see
# See this link for tutorial on this extension: https://backend.turing.edu/module3/lessons/sessions_cookies_authorization#:~:text=Authorization%20%E2%80%93%20Are%20you%20ALLOWED%20to%20do%20that%3F%3F

  end

  xit '' do
    #Another extension for further practice 
#     As a visitor or default user 
# If I try to go to any admin routes ('/admin/dashboard' or '/admin/users/:id')
# I get redirected to the landing page
# And I see a message pop up telling me I'm not authorized to access those pages. 
  end
end
