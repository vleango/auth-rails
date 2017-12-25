require "rails_helper"

RSpec.describe ProviderAuthenticable, :type => :model do
  let (:model) { User }
  let (:token_model) { UserToken }

  before(:each) do
    @user = create(:user)
  end

  describe '#user_from_provider' do
    it 'calls authorized_by_provider!' do
      expect(model).to receive(:authorized_by_provider!).with(email: @user.email)
      model.user_from_provider(email: @user.email)
    end

    context 'passes authorized_by_provider' do
      before(:each) do
        allow(model).to receive(:authorized_by_provider!).and_return(true)
      end

      context 'resource email exists' do
        it 'does not create a new resource' do
          expect{
            model.user_from_provider(email: @user.email)
          }.to_not change{ User.count }
        end

        it 'returns the resource' do
          expect(model.user_from_provider(email: @user.email)).to eq(@user)
        end
      end

      context 'resource email does not exist' do
        it 'creates a new resource' do
          expect{
            model.user_from_provider(
              email: 'random@email.com',
              first_name: 'first',
              last_name: 'last',
              userID: 'hogehoge'
            )
          }.to change{ User.count }.by(1)
        end
      end
    end
  end

  describe '#_authorized_by_provider!' do
    let (:data) {
      { name: 'my user', userID: 123 }
    }

    before(:each) do
      allow(Net::HTTP).to receive(:get_response).and_return(double(body: 'success'))
    end

    context 'response name does not match with data' do
      before(:each) do
        allow(JSON).to receive(:parse).and_return({'name' => 'failure', 'id' => data[:userID]})
      end

      it 'raises ProviderAuthFailed error' do
        expect{
          model.send(:authorized_by_provider!, data)
        }.to raise_error(UserError::ProviderAuthFailed)
      end
    end

    context 'response id does not match with data' do
      before(:each) do
        allow(JSON).to receive(:parse).and_return({'name' => data[:name], 'id' => 'failure'})
      end

      it 'raises ProviderAuthFailed error' do
        expect{
          model.send(:authorized_by_provider!, data)
        }.to raise_error(UserError::ProviderAuthFailed)
      end
    end
  end

end
