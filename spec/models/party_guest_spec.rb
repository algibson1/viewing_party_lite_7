require 'rails_helper'

RSpec.describe PartyGuest do
  describe 'relationships' do
    it { should belong_to :user }
    it { should belong_to :viewing_party }
  end
end
