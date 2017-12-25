class CustomError < StandardError
  attr_reader :status, :error, :message

  def initialize(error = 422, status = :unprocessable_entity, message = 'Something went wrong')
    @error = error
    @status = status
    @message = message
  end

end
