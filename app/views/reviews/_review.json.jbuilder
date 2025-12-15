json.extract! review, :id, :project_id, :reviewer_id, :reviewee_id, :rating, :comment, :created_at, :updated_at
json.url review_url(review, format: :json)
