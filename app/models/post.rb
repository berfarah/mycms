class Post < ActiveRecord::Base

	belongs_to :user
	has_many :metas, :as => :metable, :dependent => :destroy

	include HasTagging
	include ActionView::Helpers::SanitizeHelper
	include ActionView::Helpers::TextHelper
	before_save :set_content

	scope :shared, -> { where(type: 'Shared') }
	scope :music, -> { where(type: 'Music') }
	scope :design, -> { where(type: 'Design') }
	scope :page, -> { where(type: 'Page') }

	self.inheritance_column = :type

	attr_accessor :published_at_date, :published_at_time
	validates :title, :user_id, :type, :presence => true
	validates_format_of :published_at_time, :with => /\d{1,2}:\d{2}/
	validates :slug, :uniqueness => {
						:case_sensitive => false,
						:scope => :type
					 }

	after_initialize :get_datetimes  # Convert DB format to accessors
	before_validation :set_datetimes # Convert accessors back to DB format

	def get_datetimes
		self.published_at ||= Time.now # If the published time isn't set, set it to now

		self.published_at_date ||= self.published_at.to_date.to_s(:posts) #extract in YYYY-MM-DD format
		self.published_at_time ||= "#{'%02d' % self.published_at.hour}:#{'%02d' % self.published_at.min}" #extract the time
	end

	def set_datetimes
		self.published_at = "#{self.published_at_date} #{self.published_at_time}:00" #convert back
	end

	def type
		read_attribute(:type).presence || "Post"
	end

	def set_content
		content = sanitize self[:content], tags: %w(a br p code pre em strong b i iframe embed hr div h1 h2 h3 h4 h5)
		write_attribute(:content, content)
	end

	def content
		self[:content].html_safe
	end

	def summary
		unless self[:summary].present?
			truncate( sanitize( self[:content], tags: %w(a), attributes: %w(href class) ), :length => 80, :escape => false, :separator => ' ' )
		end
	end

	def to_param
		"#{id}/#{slug.parameterize}"
	end

	def slug=(slug)
		slug = self[:slug] || self[:title].sub("'","").parameterize
		write_attribute(:slug, slug)
	end
end