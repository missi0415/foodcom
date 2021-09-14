# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    id { 1 }
    name { 'testuser' }
    email { 'test@example.com' }
    uid { 'o9ZjWKLSopPGANCZGMDd4KdCzSH3' }
    # introduction: 'user01です。よろしくおねがいします。',
    # is_active: true,
    # header: {
    #   url: "https://rails-nuxt.s3.ap-northeast-1.amazonaws.com/uploads/default/image/defalut-header.png"
    # },
    # avatar: {
    #   url: "https://rails-nuxt.s3.amazonaws.com/uploads/default/image/defalt-avatar-gray.png"
    # },
    # admin: false
  end
end
