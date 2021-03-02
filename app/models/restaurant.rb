class Restaurant < ApplicationRecord
  belongs_to :user
  has_many :comments

  validates :name, :address, presence: true
end
