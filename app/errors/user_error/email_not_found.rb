module UserError
  class EmailNotFound < CustomError
    MSG = 'email not found'

    def initialize
      super(422, :bad_email, MSG)
    end

  end
end
