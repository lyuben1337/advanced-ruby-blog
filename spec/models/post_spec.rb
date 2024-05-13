require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:content) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:comments) }
  end

  describe 'scopes' do
    # Add tests for scopes here
  end

  describe '#status' do
    let(:post) { described_class.new }

    context 'when post is in draft' do
      it 'returns "Draft"' do
        allow(post).to receive(:draft?).and_return(true)
        expect(post.status).to eq 'Draft'
      end
    end

    context 'when post is published' do
      it 'returns "Published"' do
        allow(post).to receive(:draft?).and_return(false)
        allow(post).to receive(:published?).and_return(true)
        expect(post.status).to eq 'Published'
      end
    end

    context 'when post is scheduled' do
      it 'returns "Scheduled"' do
        allow(post).to receive(:draft?).and_return(false)
        allow(post).to receive(:published?).and_return(false)
        allow(post).to receive(:schedule?).and_return(true)
        expect(post.status).to eq 'Scheduled'
      end
    end

    context 'when status of post is not determined' do
      it 'returns "Status not determined"' do
        allow(post).to receive(:draft?).and_return(false)
        allow(post).to receive(:published?).and_return(false)
        allow(post).to receive(:schedule?).and_return(false)
        expect(post.status).to eq 'Status not determined'
      end
    end
  end
end