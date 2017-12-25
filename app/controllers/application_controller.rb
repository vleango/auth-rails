class ApplicationController < ActionController::API
  include ErrorHandler

  private

  def authenticate
    token = request.headers['x-auth']
    @user = User.find_by_token(token)
    set_token_to_header(@user.user_tokens.last.token)
  end

  private

  def set_token_to_header(token)
    response.headers['x-auth'] = token
  end

end
