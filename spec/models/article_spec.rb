require 'rails_helper'

RSpec.describe Article, :type => :model do

  describe 'validations' do
    it{ should validate_presence_of(:title) }
    it{ should validate_presence_of(:body) }
    it{ should validate_presence_of(:author) }
  end

  describe 'scopes' do
    describe 'recent' do
      it 'orders articles by published_at descending' do
        create(:article, :published, published_at: Time.now)
        create(:article, :published, published_at: Date.yesterday)
        expect(Article.recent).to be_ordered_by(:published_at, :desc)
      end
    end
  end

  describe 'callbacks' do

    describe 'after_save' do
      context 'if tags changed' do
        it 'starts RecalculateTags job' do
          expect(RecalculateTagsJob).to receive(:perform_later)
          create(:article, tags: ['test_tag'])
        end
      end

      context 'if tags not changed' do
        it 'does nothing' do
          expect(RecalculateTagsJob).not_to receive(:perform_later)
          create(:article, tags: nil)
        end
      end
    end

  end

end
