module ErrorHandler

  # called when module is included
  def self.included(klass)
    klass.class_eval do
      rescue_from StandardError do |e|
        case e.class.to_s
        when 'ActiveRecord::RecordInvalid'
          respond(422, :validation_error, e.message)
        else
          respond(500, :server_error, e.message)
        end
      end

      rescue_from CustomError do |e|
        respond(e.error, e.status, e.message)
      end
    end
  end

  private

  def respond(status, error, message)
    json = { status: status, error: error, message: message }.as_json
    render json: json
  end
end
