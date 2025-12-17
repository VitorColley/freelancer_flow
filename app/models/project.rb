class Project < ApplicationRecord
  belongs_to :client, class_name: 'User'

  has_many :proposals, dependent: :destroy
  has_one :invoice, dependent: :destroy
  has_many :reviews, dependent: :destroy

  validates :title, presence: true
  validates :description, presence: true
  validates :budget, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :status, presence: true, inclusion: { in: %w[open in_progress completed cancelled] }
  # Checks if a review has already been created by that user
  validates :project_id, uniqueness: { scope: :reviewer_id }
end
