module Helpers
  module AuthenticateHelper

    def generate_token(user, options = {})
      access = options[:access] || 'auth'
      expire_time = options[:expire_time] || 0
      token = user.send(:encode_payload, user.id, access, expire_time: expire_time)
      create(:user_token, user: user, token: token)
      token
    end

  end
end
