# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Categories
Category.create(name: "Classic Dramas")
Category.create(name: "Sports Dramas")
Category.create(name: "TV Comedies")
Category.create(name: "TV Dramas")
Category.create(name: "Family Dramas")
Category.create(name: "Dramas") 

#Videos
mrs_miniver = Video.create(title: "Mrs. Miniver", description: "Greer Garson, Walter Pidgeon, Teresa Wright and Reginald Owen star in this Academy Award-winning drama directed by the acclaimed William Wyler about an English family's efforts to rise above the hardships of war. The patriarch (Pidgeon) faces battle in Dunkirk; an air raid kills a daughter; and a son joins the Royal Air Force. Through it all, Mrs. Miniver (Garson) stands tall, strong, proud and still filled with hope.", 
  small_cover_art: Rails.root.join("public/tmp/mrs_miniver_small.jpg").open,
  large_cover_art: Rails.root.join("public/tmp/mrs_miniver_large.jpg").open, category_id: 1)
seabiscuit = Video.create(title: "Seabiscuit", description: "A knobble-kneed colt becomes a winning thoroughbred at the hands of its owner, its unorthodox trainer and its jockey, a half-blind ex-prizefighter, in this Depression-era drama based on the true story of champion racehorse Seabiscuit.", 
  small_cover_art: Rails.root.join("public/tmp/seabiscuit_small.jpg").open,
  large_cover_art: Rails.root.join("public/tmp/seabiscuit_large.jpg").open, category_id: 2)
little_women = Video.create(title: "Little Women", description: "Louisa May Alcott's beloved novel comes to life in this sensitive, soulful adaptation. Four sisters and their mother battle life's vicissitudes in Civil War-era America after their father leaves to join the conflict.", 
  small_cover_art: Rails.root.join("public/tmp/little_women_small.jpg").open,
  large_cover_art: Rails.root.join("public/tmp/little_women_large.jpg").open, category_id: 5)
downton_abbey = Video.create(title: "Downton Abbey", description: "Exposing the snobbery, backbiting and machinations of a disappearing class system, this series chronicles the comings and goings of the upper-crust Crawley family and their assorted servants.", 
  small_cover_art: Rails.root.join("public/tmp/downton_abbey_small.jpg").open,
  large_cover_art: Rails.root.join("public/tmp/downton_abbey_large.jpg").open, category_id: 4)
good_wife = Video.create(title: "The Good Wife", description: "Julianna Margulies stars as attorney Alicia Florrick, who finds herself forced to return to work after a corruption scandal lands her politician husband in prison. Though Alicia stood by him, she has a host of reasons to question their marriage.", 
  small_cover_art: Rails.root.join("public/tmp/good_wife_small.jpg").open,
  large_cover_art: Rails.root.join("public/tmp/good_wife_large.jpg").open, category_id: 4)
thirty_rock = Video.create(title: "30 Rock", description: "This smartly crafted sitcom stars Emmy-winning series creator Tina Fey as Liz Lemon, an unlucky-in-love New Yorker who heads up a ragtag team of writers on a fictional NBC variety show.", 
  small_cover_art: Rails.root.join("public/tmp/30_rock_small.jpg").open,
  large_cover_art: Rails.root.join("public/tmp/30_rock_large.jpg").open, category_id: 3)
theory_of_everything = Video.create(title: "The Theory of Everything", description: "With his body progressively ravaged by ALS, world-famous physicist Stephen Hawking must rely on his wife, Jane, to continue his life's work as he faces various challenges. This affecting biographical drama centers on the couple's fertile partnership.", 
  small_cover_art: Rails.root.join("public/tmp/theory_of_everything_small.jpg").open,
  large_cover_art: Rails.root.join("public/tmp/theory_of_everything_large.jpg").open, category_id: 6)
imitation_game = Video.create(title: "The Imitation Game", description: "Chronicling mathematical wizard Alan Turing's key role in Britain's successful effort to crack Germany's Enigma code during World War II, this historical biopic also recounts how his groundbreaking work helped launch the computer age.", 
  small_cover_art: Rails.root.join("public/tmp/imitation_game_small.jpg").open,
  large_cover_art: Rails.root.join("public/tmp/imitation_game_large.jpg").open, category_id: 4)
bletchley_circle = Video.create(title: "The Bletchley Circle", description: "Four ordinary women with an extraordinary flair for code-breaking and razor-sharp intelligence skills are the focus of this murder-mystery drama. Having served as code breakers in World War II, the four now focus their talents on catching killers.", 
  small_cover_art: Rails.root.join("public/tmp/bletchley_circle_small.jpg").open,
  large_cover_art: Rails.root.join("public/tmp/bletchley_circle_large.jpg").open, category_id: 6) 
the_fall = Video.create(title: "The Fall", description: "When the Belfast police are stalled in their investigation of a spate of murders, Detective Superintendent Stella Gibson is drafted to investigate. Under her lead, the team uncovers an intricate web of lives entangled by the killings.", 
  small_cover_art: Rails.root.join("public/tmp/the_fall_small.jpg").open,
  large_cover_art: Rails.root.join("public/tmp/the_fall_large.jpg").open, category_id: 6) 
the_hour = Video.create(title: "The Hour", description: "This six-part political thriller focuses on the launch of a new BBC news program in June 1956, as the Suez Crisis is unfolding in the Middle East. The story follows the efforts of the show's staff to reveal the tangled politics of the era.", 
  small_cover_art: Rails.root.join("public/tmp/the_hour_small.jpg").open,
  large_cover_art: Rails.root.join("public/tmp/the_hour_large.jpg").open, category_id: 6)
nurse_jackie = Video.create(title: "Nurse Jackie", description: "Edie Falco anchors this acclaimed dramedy as Jackie Peyton, a far-from-perfect but dedicated ER nurse who works in a hectic New York City hospital and relies on pain meds to get her through her exhausting days.", 
  small_cover_art: Rails.root.join("public/tmp/nurse_jackie_small.jpg").open,
  large_cover_art: Rails.root.join("public/tmp/nurse_jackie_large.jpg").open, category_id: 6)
the_americans = Video.create(title: "The Americans", description: "Set during the Reagan presidency, this Cold War drama follows two married Soviet sleeper agents living discreetly near Washington, D.C. But tensions begin to mount for the couple when a spy-hunting FBI man moves in nearby.", 
  small_cover_art: Rails.root.join("public/tmp/the_americans_small.jpg").open,
  large_cover_art: Rails.root.join("public/tmp/the_americans_large.jpg").open, category_id: 6) 

# Users
bob = User.create(full_name: "Bob Smith", email: "bobsmith@example.com", password: "bob")
john = User.create(full_name: "John Jones", email: "johnjones@example.com", password: "john")
jane = User.create(full_name: "Jane Doe", email: "janedoe@example.com", password: "jane")
# Admin User
dawn = User.create(full_name: "Dawn Miceli", email: "dawnmiceli@example.com", password: "dawn", admin: true)  

# Reviews
Review.create(user: bob, video: mrs_miniver, rating: 5, body: "This is one of my all-time favorite movies!") 
Review.create(user: john, video: mrs_miniver, rating: 3, body: "This is a good movie, but I don't really like old movies.")
