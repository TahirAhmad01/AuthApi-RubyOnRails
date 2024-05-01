class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  before_validation :set_user_role, on: :create
  has_many :refresh_tokens, dependent: :destroy
  has_many :whitelisted_tokens, dependent: :destroy
  has_many :companies

  ROLES = %w(super_admin admin user)

  validates :role, inclusion: { in: ROLES }

  def jwt_payload
    super
  end

  ROLES.each do |role_name|
    define_method "#{role_name}?" do
      role == role_name
    end
    end

  def self.jwt_revoked?(payload, user)
    token = user.jwt_allowlists.where(jti: payload['jti'], aud: payload['aud']).order(created_at: :desc).first
    return true if token.blank?

    token.update(exp: Time.current + 2.minutes.to_i)
    false
  end

  private

  def set_user_role
    self.role ||= 'user'
  end


end
