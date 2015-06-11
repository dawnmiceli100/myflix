Fabricator(:user) do
  full_name { Faker::Name.name }
  email { Faker::Internet.email } 
  password { Faker::Internet.password } 
  stripe_customer_id { Faker::Lorem.characters(10) }
  locked { false }
end