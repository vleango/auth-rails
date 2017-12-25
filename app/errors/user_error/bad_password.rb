module UserError
  class BadPassword < CustomError
    MSG = 'Bad password'

    def initialize
      super(422, :bad_password, MSG)
    end

  end
end
