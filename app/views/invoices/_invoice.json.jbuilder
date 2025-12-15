json.extract! invoice, :id, :project_id, :amount, :status, :issued_at, :created_at, :updated_at
json.url invoice_url(invoice, format: :json)
