class Music < Post
	scope :music, -> { where(type: 'Music') }
end