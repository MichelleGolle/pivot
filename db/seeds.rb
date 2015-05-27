# User.create(name: "Rachel Warbelow", email: "demo+rachel@jumpstartlab.com", password: "password")
# User.create(name: "Jeff Casimir", email: "demo+jeff@jumpstartlab.com", username: "j3", password: "password")
# User.create(name: "Jorge Talez", email: "demo+jorge@jumpstartlab.com", username: "novohispano", password: "password")
# User.create(name: "Josh Cheek", email: "demo+josh@jumpstartlab.com", username: "josh", password: "password", role: 1)
class Seed
  # seed orders, users, beer
  def self.start
    new.generate
    new.populate
  end

  def generate
    create_admins
    create_users
    create_businesses
    create_business_admins
    create_categories
    create_jobs
    create_job_categories
  end

  def populate
    populate_business_employer
  end 


  def create_admins
    User.create(name: "Josh Cheek", email: "demo+josh@jumpstartlab.com", username: "josh", password: "password", role: 2, location: "Denver")
    User.create(name: "Admin Admin", email: "admin@example.com", username: "ADMIN", password: "password", role: 2, location: "Denver")
  end

  def create_users
    20.times do
      User.create(name: Faker::Name.name, email: Faker::Internet.email, username: Faker::Internet.user_name, password: "password", role: 0, location: Faker::Address.city)
    end
  end
  
  def create_businesses
    User.create(name: "Turing School", email: "turing@example.com", username: "turing", password: "password", role: 1, location: "Denver", description: "We turn muggles into masters of code.", business_status: true)
    User.create(name: "Pivotuhl", email: "pivotuhl@example.com", username: "pivotal", password: "password", role: 1, location: "Denver", description: Faker::Hacker.say_something_smart, business_status: true)
    User.create(name: "SlowRight", email: "slow@example.com", username: "slowright", password: "password", role: 1, location: "Denver", description: Faker::Hacker.say_something_smart, business_status: true) 
    User.create(name: "Skuukom", email: "skuukom@example.com", username: "skuukom", password: "password", role: 1, location: "Denver", description: Faker::Hacker.say_something_smart, business_status: true) 
    10.times do
      User.create(name: Faker::Company.name, email: Faker::Internet.email, username: Faker::Internet.user_name, password: "password", role: 1, location: Faker::Address.city, description: Faker::Lorem.sentence(4))
    end
  end

  def populate_business_employer
    users = User.where(role:1)
    users.each { |user| user.employer_id = user.id }
  end

  def create_business_admins
    User.create(name: "Turing School Admin", email: "admin@turing.com", username: "j3", password: "password", role: 3, location: "Denver", description: "Admin for Turing School", employer: User.find_by(username: 'turing'))
    User.create(name: "Pivotuhl Admin", email: "admin@pivotal.com", username: "padmin", password: "password", role: 3, location: "Denver", description: "Admin for Pivotuhl", employer: User.find_by(username: 'pivotal'))
  end

  def create_categories
    Category.create(name: "Ruby", description: "The mother of all languages")
    Category.create(name: "Javascript", description: "The coolest kid around")
    Category.create(name: "Front-end", description: "Make stuff pretty")
    Category.create(name: "Back-end", description: "Make stuff work")
    Category.create(name: "Administrative", description: "Someone's gotta run shit")
  end

  def create_jobs
    50.times do
      Job.create(title: Faker::Name.title, description: Faker::Hacker.say_something_smart, posting_cost: rand(4..10), user_id: rand(1..User.count))
    end
  end

  def create_job_categories
    50.times do
      JobCategory.create(job_id: rand(1..(Job.all.count-1)), category_id: rand(1..(Category.all.count-1)))
    end
  end



end

Seed.start