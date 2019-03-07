module UserError
  class BadPassword < CustomError
    MSG = 'bad email or password'

    def initialize
      super(422, :authentication_error, MSG)
    end

  end
end
