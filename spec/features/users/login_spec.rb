require 'rails_helper'

RSpec.describe 'Login Page' do
  it 'links from the home page (user index)' do
    visit root_path 

    expect(page).to have_link('Log In', href: login_path)
    click_link('Log In')
    expect(page).to have_field('Email')
    expect(page).to have_field('Password')
    expect(page).to have_button('Log In')
  end

  it 'logs in a user when they enter their information' do
    ally = User.create(name: 'ally', email: 'test@example.com', password: 'password1', password_confirmation: 'password1')

    visit login_path

    fill_in('Email', with: 'test@example.com')
    fill_in('Password', with: 'password1')
    click_button('Log In')
    expect(current_path).to eq(dashboard_path)
    expect(page).to have_content("ally's Dashboard")
  end

  it 'throws an error if password is incorrect' do
    ally = User.create(name: 'ally', email: 'test@example.com', password: 'password1', password_confirmation: 'password1')

    visit login_path

    fill_in('Email', with: 'test@example.com')
    fill_in('Password', with: 'password2')
    click_button('Log In')
    expect(current_path).to eq(login_path)
    expect(page).to have_content('Sorry, those credentials are invalid')
  end

  it 'throws an error if email is incorrect (or matches no records)' do
    visit login_path

    fill_in('Email', with: 'sadtest@example.com')
    fill_in('Password', with: 'password1')
    click_button('Log In')
    expect(current_path).to eq(login_path)
    expect(page).to have_content('Sorry, those credentials are invalid')
  end
end