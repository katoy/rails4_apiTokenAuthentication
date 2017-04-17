json.products do
  json.array!(@products) do |product|
    json.partial! product
  end
end
json.status '200'
