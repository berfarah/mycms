class Tagging < ActiveRecord::Base
	belongs_to :taggable, :polymorphic => true
	belongs_to :tag

	def taggable_type=(class_name)
		super(class_name.to_s)
	end

	def self.create_taggings(taggable, tag_array)
		tags = tag_array - taggable.tags.ids # Don't add duplicates
		error = nil

		tags.select{ |x| x.present? }.each do |tag_id|
			t = taggable.taggings.new( tag_id: tag_id ) if Tag.exists?(tag_id)
			error = t unless t.save
		end

		return error
	end

	def self.destroy_taggings(taggable, tag_array)
		tags = taggable.tags.ids - tag_array # Remove tags that aren't in params
		error = nil

		tags.select{ |x| x.present? }.each do |tag_id|
			t = taggable.taggings.find_by_tag_id_and_taggable_type(tag_id, "Post")
			error = t unless t.destroy
		end

		return error
	end
end