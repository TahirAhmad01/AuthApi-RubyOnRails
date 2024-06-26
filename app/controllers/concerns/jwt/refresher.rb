module Jwt
  module Refresher
    module_function

    def refresh!(refresh_token:, decoded_token:, user:)
      raise Errors::Jwt::MissingToken, token: 'refresh' unless refresh_token.present? || decoded_token.nil?

      existing_refresh_token = RefreshToken.find_by(crypted_token: refresh_token)
      raise Errors::Jwt::InvalidToken, token: 'refresh' unless existing_refresh_token.present?

      jti = decoded_token&.fetch(:jti)
      puts "#{jti} jti.to_json"

      raise Errors::Jwt::InvalidToken, token: 'jti' unless jti.present?

      new_access_token, new_refresh_token = Jwt::Issuer.call(user)
      existing_refresh_token.destroy!

      Jwt::Blacklister.blacklist!(jti: jti, exp: decoded_token.fetch(:exp), user: user)
      Jwt::Whitelister.remove_whitelist!(jti: jti)

      [new_access_token, new_refresh_token]
    end
  end
end
