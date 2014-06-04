class Page < Post

	def to_param
		"#{slug.parameterize}"
	end

	def self.find(params)
		self.find_by_slug(params)
	end
end