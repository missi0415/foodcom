User.create!(
  name: 'ゲストユーザー',
  email: 'guest@example.com',
  uid: 'd7eREpIVM7PP1FPzxaJjy8Id0Ro1',
  introduction: 'ゲストユーザーです。よろしくおねがいします。',
  is_active: true,
  header: {
    url: "https://rails-nuxt.s3.ap-northeast-1.amazonaws.com/uploads/default/image/defalut-header.png"
  },
  avatar: {
    url: "https://rails-nuxt.s3.amazonaws.com/uploads/default/image/defalt-avatar-gray.png"
  },
  admin: false
)
User.create!(
  name: 'user01',
  email: 'user01@example.com',
  uid: 'o9ZjWKLSopPGANCZGMDd4KdCzSH3',
  introduction: 'user01です。よろしくおねがいします。',
  is_active: true,
  header: {
    url: "https://rails-nuxt.s3.ap-northeast-1.amazonaws.com/uploads/default/image/defalut-header.png"
  },
  avatar: {
    url: "https://rails-nuxt.s3.amazonaws.com/uploads/default/image/defalt-avatar-gray.png"
  },
  admin: false
)
User.create!(
  name: 'user02',
  email: 'user02@example.com',
  uid: 'pD2peNKajfQuo93zQZ976ncaOwI2',
  introduction: 'user02です。よろしくおねがいします。',
  is_active: true,
  header: {
    url: "https://rails-nuxt.s3.ap-northeast-1.amazonaws.com/uploads/default/image/defalut-header.png"
  },
  avatar: {
    url: "https://rails-nuxt.s3.amazonaws.com/uploads/default/image/defalt-avatar-gray.png"
  },
  admin: false
)
User.create!(
  name: 'user03',
  email: 'user03@example.com',
  uid: 'gwqZZWE0R9So1vIw0Jl6UGhvN3A2',
  introduction: 'user03です。よろしくおねがいします。',
  is_active: true,
  header: {
    url: "https://rails-nuxt.s3.ap-northeast-1.amazonaws.com/uploads/default/image/defalut-header.png"
  },
  avatar: {
    url: "https://rails-nuxt.s3.amazonaws.com/uploads/default/image/defalt-avatar-gray.png"
  },
  admin: false
)
User.create!(
  name: 'user04',
  email: 'user04@example.com',
  uid: 'HjHapRCk6WZhZ96Trnd3faRh7kT2',
  introduction: 'user04です。よろしくおねがいします。',
  is_active: true,
  header: {
    url: "https://rails-nuxt.s3.ap-northeast-1.amazonaws.com/uploads/default/image/defalut-header.png"
  },
  avatar: {
    url: "https://rails-nuxt.s3.amazonaws.com/uploads/default/image/defalt-avatar-gray.png"
  },
  admin: false
)
User.create!(
  name: 'user05',
  email: 'user05@example.com',
  uid: 'U4lk4Caykda6zrNQqJl6cysn1Dk2',
  introduction: 'user03です。よろしくおねがいします。',
  is_active: true,
  header: {
    url: "https://rails-nuxt.s3.ap-northeast-1.amazonaws.com/uploads/default/image/defalut-header.png"
  },
  avatar: {
    url: "https://rails-nuxt.s3.amazonaws.com/uploads/default/image/defalt-avatar-gray.png"
  },
  admin: false
)
User.create!(
  name: 'user06',
  email: 'user06@example.com',
  uid: 'Mm8E0MQGK0VGqOfkY97QTtjtd5G2',
  introduction: 'user06です。よろしくおねがいします。',
  is_active: true,
  header: {
    url: "https://rails-nuxt.s3.ap-northeast-1.amazonaws.com/uploads/default/image/defalut-header.png"
  },
  avatar: {
    url: "https://rails-nuxt.s3.amazonaws.com/uploads/default/image/defalt-avatar-gray.png"
  },
  admin: false
)


1000.times do |i|
  Post.create!(
    user_id: 2,
    content: "post content#{i+1}"
  )
end
1000.times do |i|
  Post.create!(
    user_id: 3,
    content: "post content#{i+1}"
  )
end
1000.times do |i|
  Post.create!(
    user_id: 4,
    content: "post content#{i+1}"
  )
end
1000.times do |i|
  Post.create!(
    user_id: 5,
    content: "post content#{i+1}"
  )
end
1000.times do |i|
  Post.create!(
    user_id: 6,
    content: "post content#{i+1}"
  )
end
1000.times do |i|
  Post.create!(
    user_id: 7,
    content: "post content#{i+1}"
  )
end
