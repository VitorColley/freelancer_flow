class Proposal < ApplicationRecord

  belongs_to :project
  belongs_to :freelancer, class_name: 'User'

  validates :message, presence: true
  validates :bid_amount, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :status, presence: true, inclusion: { in: %w[pending accepted rejected] }
  validates :freelancer_id, uniqueness: {
    scope: :project_id,
    message: "has already submitted a proposal for this project"
  }

  after_initialize :set_default_status, if: :new_record?

  private

  def set_default_status
    self.status ||= "pending"
  end
end
