require 'net/http'

module ProviderAuthenticable
  extend ActiveSupport::Concern

  included do
    has_secure_password
  end

  module ClassMethods
    def user_from_provider(data)
      authorized_by_provider!(data)
      resource = find_by_email(data[:email])
      if resource.blank?
        resource = create(
          first_name: data[:first_name],
          last_name: data[:last_name],
          email: data[:email],
          password: data[:userID],
          password_confirmation: data[:userID]
        )
      end
      resource
    end

    private

    def authorized_by_provider!(data)
      uri = URI("https://graph.facebook.com/me?access_token=#{data[:accessToken]}")
      response = Net::HTTP.get_response(uri)
      json_response = JSON.parse(response.body)
      if json_response['name']&.downcase != data[:name]&.downcase || json_response['id'] != data[:userID]
        raise UserError::ProviderAuthFailed
      end
    end
  end

end
