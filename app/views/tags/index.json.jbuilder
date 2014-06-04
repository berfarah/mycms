json.array!(@tags) do |tag|
  json.extract! tag, :id, :name, :slug, :description
  json.url tag_url(tag, format: :json)
end
