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

admin = Admin.find_or_create_by!(username: 'admin') do |user|
  user.password= '12345678'
  user.password_confirmation= '12345678'
  user.role= 'super_admin'
  user.save!
end

# Create a default customer user
if Customer.count == 0
  customer = Customer.new
  customer.phone= '1234567890'
  customer.email = 'mail@gmail.com'
  customer.full_name = 'John Doe'
  customer.username = 'johndoe'
  customer.password = '12345678'
  customer.password_confirmation = '12345678'
  customer.save!
end

# Create a default driver user
if Driver.count == 0
  driver = Driver.new
  driver.phone= '1234567890'
  driver.email = 'drivermail@gmail.com'
  driver.full_name = 'Driver Doe'
  driver.username = 'driverdoe'
  driver.password = '12345678'
  driver.password_confirmation = '12345678'
  driver.save!
end