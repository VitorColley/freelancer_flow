class Proposal < ApplicationRecord

  belongs_to :project
  belongs_to :freelancer, class_name: 'User'

  validates :message, presence: true
  validates :bid_amount, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :status, presence: true, inclusion: { in: %w[pending accepted rejected] }
end
