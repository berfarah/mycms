module HasTagging
	extend ActiveSupport::Concern

	included do
		after_save :save_taggings
		has_many :taggings, :as => :taggable, :dependent => :destroy
		has_many :tags, :through => :taggings
		accepts_nested_attributes_for :tags
		attr_reader :tag_tokens
	end

	def tag_tokens=(tokens)
		@tag_tokens = Tag.ids_from_tokens(tokens)
	end

	def save_taggings
		tag_array = @tag_tokens
		Tagging.create_taggings(self, tag_array)
		Tagging.destroy_taggings(self, tag_array)
	end
end