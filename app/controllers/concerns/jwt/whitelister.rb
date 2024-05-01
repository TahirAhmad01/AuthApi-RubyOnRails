
module Jwt
  module Whitelister
    extend self

    def whitelist!(jti:, exp:, user:)
      user.whitelisted_tokens.create!(
        jti: jti,
        exp: Time.at(exp)
      )
    end

    def remove_whitelist!(jti:)
      whitelist = WhitelistedToken.find_by(jti: jti)
      whitelist.destroy if whitelist
    end

    def whitelisted?(jti:)
      WhitelistedToken.exists?(jti: jti)
    end
  end
end