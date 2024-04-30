module TokenService
  def self.generate_token(user)
    Warden::JWTAuth::TokenEncoder.new.call(user, :jti)
  end
end
