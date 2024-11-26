# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


# Create a default admin user

# admin = Admin.find_or_create_by!(username: 'admin') do |user|
#   user.password= '12345678'
#   user.password_confirmation= '12345678'
#   user.role= 'super_admin'
#   user.save!
# end
# #
# # # Create a default customer user
# if Customer.count == 0
#   10.times do |i|
#     customer = Customer.new
#     customer.phone= Faker::PhoneNumber.cell_phone
#     customer.email = Faker::Internet.email
#     customer.full_name = Faker::Name.name
#     customer.username = Faker::Internet.username
#     customer.password = '12345678'
#     customer.password_confirmation = '12345678'
#     customer.avatar_link= Faker::Avatar.image
#     customer.save!
#   end
# end
#
# # # Create a default driver user
if Driver.count == 1
  10.times do |i|
    driver = Driver.new
    driver.phone= Faker::PhoneNumber.cell_phone
    driver.email = Faker::Internet.email
    driver.full_name = Faker::Name.name
    driver.username = Faker::Internet.username
    driver.password = '12345678'
    driver.password_confirmation = '12345678'
    driver.avatar_link= Faker::Avatar.image
    driver.save!
  end
end
#
# # Create places
# if Place.count == 0
#   10.times do |i|
#     Place.create(name: "#{Faker::Address.city} #{Faker::Address.full_address}")
#   end
#
#   # create PlaceExpense
#   places = Place.all
#   length = places.length
#
#   for i in 0..length-2
#     for j in i+1..length-1
#       PlaceExpense.create(from_place_id: places[i].id, to_place_id: places[j].id, price: rand(1..10) * 1000)
#     end
#   end
#
#
#
#
# end
