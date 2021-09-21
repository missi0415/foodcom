require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'ユーザーバリデーションテスト' do
    let!(:user) { FactoryBot.create(:user) }

    it 'バリデーションが有効なこと' do
      expect(user).to be_valid
    end

    it '名前が空欄でないこと' do
      user.name = ''
      expect(user).to be_invalid
    end

    it 'メールアドレスが空欄でないこと' do
      user.email = ''
      expect(user).to be_invalid
    end

    it 'メールアドレスが一意であること' do
      test_user = User.create(email: 'test@example.com', name: 'test2', uid: '111111')
      expect(test_user).to be_invalid
    end

    it 'uidが空欄でないこと' do
      user.uid = ''
      expect(user).to be_invalid
    end

    it '自己紹介が空欄を許可すること' do
      user.introduction = ''
      expect(user).to be_valid
    end

    it '自己紹介が140文字以内であること' do
      user.introduction = 'a' * 141
      expect(user).to be_invalid
    end
    
  end
end
