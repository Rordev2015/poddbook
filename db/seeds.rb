User.create!(f_name: "Example",
             l_name: "User",
             email: "example@hell.com",
             password: "password",
             password_confirmation: "password",
             city: "NY",
             gender: "male",
             admin: true,
             activated: true,
             activated_at: Time.zone.now)
             
99.times do |n|
    f_name = Faker::Name.first_name
    l_name = Faker::Name.last_name
    email = "example-#{n+1}@finite.com"
    password = "password"
    User.create!(f_name: f_name,
                 l_name: l_name,
                 email: email,
                 password: password, 
                 password_confirmation: password,
                 city: "NY",
                 gender: "male",
                 activated: true,
                 activated_at: Time.zone.now)
                 
end
users = User.order(:created_at).take(6)
50.times do
content = Faker::Lorem.sentence(5)
users.each { |user| user.microposts.create!(content: content) }
end