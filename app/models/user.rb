class User < ApplicationRecord
  include Authenticable
  include ProviderAuthenticable

  has_many :user_tokens, dependent: :destroy

  validates :first_name, :last_name, :email, :password, presence: :true
  validates :email, uniqueness: { case_sensitive: false }, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, on: :create }
  before_save :format_attributes!

  private

  def format_attributes!
    self.email = email.downcase
    self.first_name = format_name(first_name)
    self.last_name = format_name(last_name)
  end

  def format_name(string)
    string.humanize.gsub(/\b([a-z])/) { $1.capitalize }
  end

end
