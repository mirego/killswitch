FactoryBot.define do
  factory :user do
    # Attributes
    name { FFaker::Name.name }
    email { FFaker::Internet.email }
    password { FFaker.bothify('?#?#?#?#?#?#?#?#?#}') }
  end
end
