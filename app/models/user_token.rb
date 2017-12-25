class UserToken < ApplicationRecord
  belongs_to :user

  validates :access, :token, presence: true

  def self.remove_token(token)
    user_token = find_by_token(token)
    user_token.destroy if user_token
  end

end
