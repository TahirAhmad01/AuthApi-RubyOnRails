require_relative '../../config/initializers/devise'

class JwtBlacklist < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Denylist

  self.table_name = 'jwt_blacklist'
end