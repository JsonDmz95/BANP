# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

require "faker"

100.times do |count|
  Employee.create(
    id: (count + 1),
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    phone: "(#{Faker::Number.number(3)}) #{Faker::Number.number(3)}-#{Faker::Number.number(4)}",
    role: ["Administrator", "Seller", "Driver"].sample,
    email: Faker::Internet.email,
    password_digest: Faker::Crypto.md5,
    state: Faker::Boolean.boolean(0.8)
  )
end

puts "The information have been seeded"
