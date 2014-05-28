class Page < Post
	scope :page, -> { where(type: 'page') }

	def to_param
		"#{slug.parameterize}"
	end

	def self.find(params)
		self.find_by_slug(params)
	end
end