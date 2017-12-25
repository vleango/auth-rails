require "rails_helper"

RSpec.describe Authenticable, :type => :model do
  let (:model) { User }
  let (:token_model) { UserToken }

  before(:each) do
    @user = create(:user)
  end

  describe '#self.find_by_token' do
    context 'token has expired' do
      let (:token) { generate_token(@user) }
      it 'calls remove_token and raises ExpiredToken error' do
        expect(token_model).to receive(:remove_token).with(token)
        expect{
          model.find_by_token(token)
        }.to raise_error(UserError::ExpiredToken)
      end
    end

    context 'token was decoded' do
      let (:exp) { Time.now.to_i + 100 }
      let (:token) { generate_token(@user, expire_time: exp) }
      it 'returns the resource' do
        expect(model.find_by_token(token)).to eq(@user)
      end

      it 'calls refresh_auth_token' do
        decoded_token = {"id" => @user.id, "access" => 'auth', "exp" => exp}
        expect_any_instance_of(model)
          .to receive(:refresh_auth_token).with(token, decoded_token)
        model.find_by_token(token)
      end
    end
  end

  describe '#self.find_by_credentials!' do
    context 'email not found' do
      it 'raises EmailNotFound error' do
        expect{
          model.find_by_credentials!('test', 'pass')
        }.to raise_error(UserError::EmailNotFound)
      end
    end

    context '#authenticate' do
      context 'passes authenticate' do
        before(:each) do
          allow_any_instance_of(model).to receive(:authenticate).and_return(true)
        end

        it 'returns the resource' do
          expect(model.find_by_credentials!(@user.email, 'pass')).to eq(@user)
        end
      end

      context 'fails authenticate' do
        before(:each) do
          allow_any_instance_of(model).to receive(:authenticate).and_return(false)
        end

        it 'raises BadPassword error' do
          expect{
            model.find_by_credentials!(@user.email, 'pass')
          }.to raise_error(UserError::BadPassword)
        end
      end
    end
  end

  describe '#generate_auth_token' do
    it 'creates a new user_token for the resource' do
      expect{
        @user.generate_auth_token('auth')
      }.to change{ @user.user_tokens.count }.by(1)
    end
  end

  describe '#refresh_auth_token' do
    it 'updates the old token' do
      refreshed_token = 'refreshed'
      token = generate_token(@user)
      user_token = @user.user_tokens.create(access: 'auth', token: token)
      decoded_token = {"id" => @user.id, "access" => 'auth'}
      expect{
        @user.refresh_auth_token(token, decoded_token)
      }.to change{ user_token.reload.token }.from(token)
    end
  end

end
