FactoryBot.define do
  factory :behavior do
    # Attributes
    version_number { "#{Random.rand(1..10)}.#{Random.rand(1..9)}.#{Random.rand(1..9)}" }
    version_operator { Behavior::VERSION_OPERATORS.keys.sample }
    language { nil }
    data { '{"action":"ok"}' }

    association :project
  end
end
