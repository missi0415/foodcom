require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'ポストモデルバリデーションテスト' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:post) { FactoryBot.create(:post) }
    
    it 'バリデーションが有効なこと' do
      expect(post).to be_valid
    end

    it '投稿が空欄でないこと' do
      post.content = ''
      expect(post).to be_invalid
    end

    it '投稿が140文字以下なら有効' do
      post.content = 'a' * 140
      expect(post).to be_valid
    end

    it '投稿が140文字以上なら無効' do
      post.content = 'a' * 141
      expect(post).to be_invalid
    end
  end
end
