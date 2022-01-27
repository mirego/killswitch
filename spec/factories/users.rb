FactoryGirl.define do
  factory :user do
    # Attributes
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker.bothify('?#?#?#?#?#?#?#?#?#}') }
  end
end
