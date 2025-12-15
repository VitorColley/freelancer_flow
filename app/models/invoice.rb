class Invoice < ApplicationRecord
  belongs_to :project

  validates :amount, numericality: { greater_than_or_equal_to: 0 }
  validates :status, presence: true, inclusion: { in: %w[unpaid paid] }
end
