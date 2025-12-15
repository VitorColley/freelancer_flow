json.extract! portfolio_item, :id, :freelancer_id, :title, :description, :url, :created_at, :updated_at
json.url portfolio_item_url(portfolio_item, format: :json)
