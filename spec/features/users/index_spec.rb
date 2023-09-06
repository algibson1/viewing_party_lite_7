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
end
