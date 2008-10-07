Factory.sequence(:email) { |n| "user#{n}@example.com" }

Factory.define(:user) do |user|
  user.name 'Bob Loblaw'
  user.email Factory.next(:email)
  user.password 'foo'
end