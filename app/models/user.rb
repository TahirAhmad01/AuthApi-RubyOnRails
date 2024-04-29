class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  before_validation :set_user_role, on: :create
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

  private

  def set_user_role
    self.role ||= 'user'
  end
end
