User.create! name: "Thang",
  email: "tranthang.yb@outlook.com",
  password: "111111",
  password_confirmation: "111111",
  admin: true

User.create! name: "Cậu Vàng",
  email: "cauvang@laohac.com",
  password: "123123",
  password_confirmation: "123123"

99.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create! name: name,
    email: email,
    password: password,
    password_confirmation: password
end
