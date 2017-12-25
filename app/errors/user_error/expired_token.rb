module UserError
  class ExpiredToken < CustomError
    MSG = 'expired token'

    def initialize
      super(422, :expired_token, MSG)
    end

  end
end
