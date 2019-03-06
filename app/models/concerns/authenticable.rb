module Authenticable
  extend ActiveSupport::Concern

  HMAC_SECRET = Rails.application.credentials.hmac_secret
  TOKEN_EXPIRES_TIME = Time.now.to_i + 60 * 60 * 24 * 7 # 1 week

  included do
    has_secure_password
  end

  module ClassMethods
    def find_by_token(jwt_token)
      begin
        decoded_token = JWT.decode jwt_token, HMAC_SECRET, true, { :algorithm => 'HS256' }
        user = find(decoded_token.first['id'])
        user.refresh_auth_token(jwt_token, decoded_token.first)
        return user
      rescue JWT::ExpiredSignature
        UserToken.remove_token(jwt_token)
        raise UserError::ExpiredToken
      end
    end

    def find_by_credentials!(email, password)
      resource = find_by_email(email)
      raise UserError::EmailNotFound if resource.blank?
      raise UserError::BadPassword unless resource.authenticate(password)
      resource
    end
  end

  def generate_auth_token(access)
    token = encode_payload(self.id, access)
    user_tokens.create!(access: access, token: token)
  end

  def refresh_auth_token(jwt_token, decoded_token)
    refreshed_token = encode_payload(decoded_token["id"], decoded_token["auth"])
    user_token = UserToken.find_by_token(jwt_token)
    user_token.update_attributes!(token: refreshed_token)
    refreshed_token
  end

  private

  def encode_payload(id, access, options = {})
    expires = options[:expire_time].present? ? options[:expire_time] : TOKEN_EXPIRES_TIME
    payload = { id: id, access: access, exp: expires }
    JWT.encode payload, HMAC_SECRET, 'HS256'
  end

end
