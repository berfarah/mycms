class Design < Post
	scope :design, -> { where(type: 'Design') }
end