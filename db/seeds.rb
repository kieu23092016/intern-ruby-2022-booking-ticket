start=1462556336
10.times do |n|
  user_name = "Michael Harlt"
  email = "example-#{n + 200}@gmail.com"
  password = "password"
  activation_token = User.new_token
  User.create!(user_name: user_name,
    email: email,
    phone: start,
    password: password,
    password_confirmation: password,
    date_birth: "1998-02-02",
    sex: true,
    admin: false,
    activated: true,
    activated_at: Time.zone.now,
    activation_token: activation_token,
    activation_digest: User.digest(activation_token))
    start = start+1
end
