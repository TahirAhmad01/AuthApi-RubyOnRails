# app/models/refresh_token.rb
class RefreshToken < ApplicationRecord
  belongs_to :user
  before_create :generate_token

  private

  def generate_token
    self.crypted_token = SecureRandom.hex
  end
end
