User.create! name: "Thang",
  email: "tranthang.yb@outlook.com",
  password: "111111",
  password_confirmation: "111111",
  admin: true,
  activated: true,
  activated_at: Time.zone.now

User.create! name: "Cậu Vàng",
  email: "cauvang@laohac.com",
  password: "123123",
  password_confirmation: "123123",
  activated: true,
  activated_at: Time.zone.now

99.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create! name: name,
    email: email,
    password: password,
    password_confirmation: password,
    activated: true,
    activated_at: Time.zone.now
end

users = User.order_by_name.take 6
content = Faker::Lorem.sentence 5
25.times do
  users.each do |user|
    user.microposts.create! content: content
  end
end

# Following relationships
users = User.all
user = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
