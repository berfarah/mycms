class Tag < ActiveRecord::Base
	scope :finder, lambda { |q| where("name like :q", q: "%#{q}%") }

	has_many :taggings, :dependent => :destroy

	has_many :posts,  :through     => :taggings,
					  :source      => :taggable,
					  :source_type => "Post",
					  :class_name  => 'Post'

	has_many :design, :through     => :taggings,
					  :source      => :taggable,
					  :source_type => "Design"

	has_many :music, :through     => :taggings,
					  :source      => :taggable,
					  :source_type => "Music"

	has_many :shared, :through     => :taggings,
					  :source      => :taggable,
					  :source_type => "Shared"

	validates :name, presence: true, uniqueness: true
	validates :slug, :uniqueness => {
		             :case_sensitive => false
	}

	def slug=(slug)
		slug = self[:name].sub("'","").parameterize if self[:slug].present?
		write_attribute(:slug, slug)
	end

	def to_param
		"#{slug.parameterize}"
	end

	def self.ids_from_tokens(tokens)
		tokens.gsub!(/<<(.+?)>>/) { create!(name: $1, slug: $1.parameterize).id }
		tokens.split(',')
	end

	def self.find(params)
		self.find_by_slug(params)
	end

	def as_json(options)
		{ id: id, text: name }
	end
end