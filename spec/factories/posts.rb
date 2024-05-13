FactoryBot.define do
  factory :post do
    title {"zxcTitle"}
    content { "chell" }
    published_at { Time.now }
  end
end
