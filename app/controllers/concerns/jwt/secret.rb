module Jwt
  module Secret
    module_function

    def secret
      ENV['JWT_SECRET_KEY']
    end
  end
end