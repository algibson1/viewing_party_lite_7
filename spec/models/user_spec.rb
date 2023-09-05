require 'rails_helper'

RSpec.describe User do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :email }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of :password }
    it { should validate_presence_of :password_confirmation }
    it { should have_secure_password }

    it 'encrypts passwords' do
      user = User.create(name: 'Meg', email: 'meg@test.com', password: 'password123', password_confirmation: 'password123')
      expect(user).to_not have_attribute(:password)
      expect(user).to_not have_attribute(:password_confirmation)
      expect(user.password_digest).to_not eq('password123')
    end
  end

  describe 'relationships' do
    it { should have_many :party_guests }
    it { should have_many(:viewing_parties).through(:party_guests) }
  end

  it 'can find all users besides the current logged in one' do
    @ally = User.create!(name: 'Ally Jean', email: 'allyjean@example.com', password: 'password1', password_confirmation: 'password1')
    @jimmy = User.create!(name: 'Jimmy Jean', email: 'jimmyjean@example.com', password: 'password2', password_confirmation: 'password2')
    @bobby = User.create!(name: 'Bobby Jean', email: 'bobbyjean@example.com', password: 'password3', password_confirmation: 'password3')
    @dennis = User.create!(name: 'Dennis Jean', email: 'dennisjean@example.com', password: 'password4', password_confirmation: 'password4')
    expect(@ally.friends).to match_array([@jimmy, @bobby, @dennis])
    expect(@jimmy.friends).to match_array([@ally, @bobby, @dennis])
    expect(@bobby.friends).to match_array([@jimmy, @ally, @dennis])
    expect(@dennis.friends).to match_array([@jimmy, @bobby, @ally])
  end
end
