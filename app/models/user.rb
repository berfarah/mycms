class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :confirmable, :validatable, :authentication_keys => [:login]

  has_many :posts, :dependent => :destroy
  delegate :design, :music, :shared, :page, :to => :posts
  has_many :metas, :as => :metable, :dependent => :destroy, :autosave => true

  validates :username,
        :uniqueness => {
          :case_sensitive => false
        }

  accepts_nested_attributes_for :metas

  def login=(login)
  	@login = login
  end

  def login
  	@login || self.username || self.email
  end

  def password_required?
  	super if confirmed?
  end

  def password_match?
  	self.errors[:password] << "can't be blank" if password.blank?
  	self.errors[:password_confirmation] << "can't be blank" if password_confirmation.blank?
  	self.errors[:password_confirmation] << "does not match password" if password != password_confirmation
  	password == password_confirmation && !password.blank?
  end

  # Overwrite find_for_database_authentication
  def self.find_first_by_auth_conditions(warden_conditions)
  	conditions = warden_conditions.dup
  	if login = conditions.delete(:login)
  		where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
  	else
  		where(conditions).first
  	end
  end


end
