class Review < ApplicationRecord
  belongs_to :project
  belongs_to :reviewer, class_name: 'User'
  belongs_to :reviewee, class_name: 'User'

  validates :rating, inclusion: { in: 1..5 }
  validates :comment, presence: true
end
