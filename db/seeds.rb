# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
if User.count == 0
	@user = User.new(:username => 'ber@farah', :email => 'ber@bernardo.me')
	@user.save
	# need to find user and update to admin
	@user.update_attribute :admin, true
end