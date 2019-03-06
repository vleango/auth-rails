FactoryBot.define do
  factory :user_token do
    access { 'auth' }
    token { Faker::Lorem.characters(25) }
  end
end
