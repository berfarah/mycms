class Shared < Post
	has_many :taggings, :as => :taggable
end