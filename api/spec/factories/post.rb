FactoryBot.define do
  factory :post do
    id { 1 }
    user_id { 1 }
    content { 'ごはんが美味しいです' }
    post_id { 0 }
  end
end
