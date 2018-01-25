module AuthRails
  module V1
    module Auth
      class AuthenticateController < ApplicationController

        def login
          @user = User.find_by_credentials!(user_params[:email], user_params[:password])
          user_token = @user.generate_auth_token('auth')
          set_token_to_header(user_token.token)
          render :user
        end

        def register
          @user = User.create!(user_params)
          user_token = @user.generate_auth_token('auth')
          set_token_to_header(user_token.token)
          render :user
        end

        def provider
          @user = User.user_from_provider(provider_params)
          user_token = @user.generate_auth_token(provider_params[:access])
          set_token_to_header(user_token.token)
          render :user
        end

        def logout
          token = request.headers['x-auth']
          payload = { status: 200, message: 'succcess' }
          if token.present?
            UserToken.remove_token(token)
          else
            payload = { status: 422, message: 'failure' }
          end
          render json: payload.as_json
        end

        private

        def user_params
          params.require(:user)
            .permit(:first_name, :last_name, :email, :password, :password_confirmation)
        end

        def provider_params
          params.require(:provider)
            .permit(:email, :name, :first_name, :last_name, :password, :access, :accessToken, :userID)
        end

      end
    end
  end
end
