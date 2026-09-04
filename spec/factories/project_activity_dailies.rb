FactoryBot.define do
  factory :project_activity_daily do
    # Associations
    association :project

    # Attributes
    date { Date.current }
    request_count { 0 }
  end
end
