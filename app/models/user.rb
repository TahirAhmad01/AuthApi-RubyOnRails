class User < ApplicationRecord
  has_many :companies
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  ROLES = %w{super_admin admin user}
  validates :role, inclusion: { in: ROLES }
  # validate :password_confirmation_match, on: :create

  def jwt_payload
    super
  end

  ROLES.each do |role_name|
    define_method "#{role_name}?" do
      role == role_name
    end
  end

  private

  # def password_confirmation_match
  #   errors.add(:password_confirmation, "doesn't match Password") if password != password_confirmation
  # end
end
