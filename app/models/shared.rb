class Shared < Post
	scope :shared, -> { where(type: 'shared') }
end