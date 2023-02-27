FactoryBot.define do
  factory :project do
    # Attributes
    name { FFaker::Company.name }

    # Associations
    association :application
  end
end
