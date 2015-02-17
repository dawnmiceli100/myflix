Fabricator(:queue_item) do
  #queue_position { (1..100).to_a.sample }
  queue_position { 1 }
end