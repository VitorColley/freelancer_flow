class PortfolioItem < ApplicationRecord
  belongs_to :freelancer, class_name: 'User'

  validates :title, presence: true
  validates :description, presence: true
end
