require "rails_helper"

RSpec.describe UserToken, :type => :model do

  describe '#self.remove_token' do
    before(:each) do
      user_token = create(:user_token, user: build_stubbed(:user))
      @token = user_token.token
    end

    context 'token not found' do
      it 'does not delete any tokens' do
        expect{
          described_class.remove_token('something else')
        }.to_not change{ described_class.all.count }
      end
    end

    context 'token found' do
      it 'deletes the token' do
        expect{
          described_class.remove_token(@token)
        }.to change{ described_class.all.count }.by(-1)
      end
    end
  end
end
