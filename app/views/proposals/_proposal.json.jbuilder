json.extract! proposal, :id, :project_id, :freelancer_id, :message, :bid_amount, :status, :created_at, :updated_at
json.url proposal_url(proposal, format: :json)
