json.array!(@posts) do |post|
  json.extract! post, :id, :user_id, :date, :title, :summary, :content, :content_html, :slug, :type
  json.url post_url(post, format: :json)
end
