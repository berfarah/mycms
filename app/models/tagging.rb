class Tagging < ActiveRecord::Base
	belongs_to :taggable, :polymorphic => true
	belongs_to :tag

	def taggable_type=(class_name)
		super(class_name.constantize.base_class.to_s)
	end
end