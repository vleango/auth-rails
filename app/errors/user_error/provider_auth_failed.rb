module UserError
  class ProviderAuthFailed < CustomError
    MSG = 'failed to authenticate with the provider'

    def initialize
      super(422, :provider_auth_failed, MSG)
    end

  end
end
