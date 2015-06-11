Fabricator(:payment) do
  amount { 999 }
  stripe_charge_id { Faker::Lorem.characters(10) }
end