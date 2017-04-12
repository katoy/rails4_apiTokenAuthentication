json.extract! product, :id, :name, :age, :email, :created_at, :updated_at
json.url product_url(product, format: :json)
