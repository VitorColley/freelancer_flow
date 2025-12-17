class Invoice < ApplicationRecord
  belongs_to :project

  validates :amount, numericality: { greater_than_or_equal_to: 0 }
  validates :status, presence: true, inclusion: { in: %w[unpaid paid] }

  after_initialize :set_default_status, if: :new_record?

  private

  def set_default_status
    self.status ||= "unpaid"
  end
end
