class Company < ApplicationRecord
  belongs_to :user
  validates :name, presence: true, uniqueness: true
  validates :established_year, :address, presence: true
end
