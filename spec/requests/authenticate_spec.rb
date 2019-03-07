require 'rails_helper'

RSpec.describe 'Authenticate', :type => :request do
  describe '#login' do
    context 'email does not exist' do
      before(:each) do
        post '/v1/auth/login', params: { user: { email: 'test'} }
      end

      it 'returns email not found error' do
        json_response = JSON.parse(response.body)
        expect(response.status).to eq(422)
        expect(json_response['error']).to eq('authentication_error')
        expect(json_response['message']).to eq('bad email or password')
      end

      it 'does not set the x-auth token' do
        expect(response.headers['X-Auth']).to be_nil
      end
    end

    context 'bad password' do
      before(:each) do
        user = create(:user)
        post '/v1/auth/login', params: { user: { email: user.email} }
      end

      it 'returns bad password error' do
        json_response = JSON.parse(response.body)
        expect(response.status).to eq(422)
        expect(json_response['error']).to eq('authentication_error')
        expect(json_response['message']).to eq('bad email or password')
      end

      it 'does not set the x-auth token' do
        expect(response.headers['X-Auth']).to be_nil
      end
    end

    context 'valid login' do
      let (:user) { create(:user) }
      before(:each) do
        post '/v1/auth/login', params: { user: {email: user.email, password: user.password} }
      end

      it 'returns the user json' do
        json_response = JSON.parse(response.body)
        expect(json_response['user']['first_name']).to eq(user.first_name)
        expect(json_response['user']['last_name']).to eq(user.last_name)
        expect(json_response['user']['email']).to eq(user.email)
      end

      it 'sets the x-auth header token' do
        expect(response.headers['X-Auth']).to_not be_nil
      end
    end
  end

  describe '#register' do
    context 'missing params' do
      before(:each) do
        post '/v1/auth/register', params: { user: {first_name: 'test'} }
      end

      it 'returns a validation error' do
        json_response = JSON.parse(response.body)
        expect(response.status).to eq(422)
        expect(json_response['error']).to eq('validation_error')
        expect(json_response['message']).to eq("Validation failed: Password can't be blank, Last name can't be blank, Email can't be blank, Email is invalid")
      end
    end

    context 'user created' do
      let (:user) { build(:user) }

      before(:each) do
        post '/v1/auth/register', params: { user: {
          first_name: user.first_name,
          last_name: user.last_name,
          email: user.email,
          password: user.password,
          password_confirmation: user.password_confirmation
        }}
      end

      it 'returns the user json' do
        json_response = JSON.parse(response.body)
        expect(json_response['user']['first_name']).to eq(user.first_name)
        expect(json_response['user']['last_name']).to eq(user.last_name)
        expect(json_response['user']['email']).to eq(user.email)
      end

      it 'sets the x-auth header token' do
        expect(response.headers['X-Auth']).to_not be_nil
      end
    end
  end

  describe '#provider' do
    context 'missing params' do
      before(:each) do
        stub_request(:any, /graph.facebook.com/).to_return(body: {error: 'error'}.to_json)
        post '/v1/auth/provider', params: { provider: {name: 'test'} }
      end

      it 'returns a validation error' do
        json_response = JSON.parse(response.body)
        expect(response.status).to eq(422)
        expect(json_response['error']).to eq('provider_auth_failed')
        expect(json_response['message']).to eq('failed to authenticate with the provider')
      end
    end

    context 'user created' do
      before(:each) do
        stub_request(:any, /graph.facebook.com/).to_return(body: {name: 'Bob Hope', id: '123'}.to_json)
        post '/v1/auth/provider', params: { provider: {
          name: 'Bob Hope',
          first_name: 'Bob',
          last_name: 'Hope',
          email: 'test@email.com',
          userID: '123',
          access: 'a provider'
        }}
      end

      it 'sets the x-auth header token' do
        expect(response.headers['X-Auth']).to_not be_nil
      end
    end
  end

  describe '#logout' do
    context 'x-auth is present' do
      it 'removes the token' do
        user_token = create(:user_token, user: build_stubbed(:user))

        expect{
          delete '/v1/auth/logout', headers: { 'x-auth': user_token.token }
        }.to change{UserToken.count}.by(-1)
      end

      it 'returns 200 status' do
        user_token = create(:user_token, user: build_stubbed(:user))
        delete '/v1/auth/logout', headers: { 'x-auth': user_token.token }
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq(200)
      end
    end

    context 'x-auth is not present' do
      it 'does not call remove_token' do
        expect(UserToken).to_not receive(:remove_token)
        delete '/v1/auth/logout'
      end

      it 'returns 422 error' do
        user_token = create(:user_token, user: build_stubbed(:user))
        delete '/v1/auth/logout'
        json_response = JSON.parse(response.body)
        expect(json_response['status']).to eq(422)
      end
    end
  end

end
