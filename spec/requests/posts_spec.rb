require 'rails_helper'

RSpec.describe "PostsController", type: :request do
  # Mock data
  let(:user) { FactoryBot.create(:user) }
  let(:user_post) { FactoryBot.create(:post, user_id: user.id) }

  describe "GET /posts" do
    it "returns a successful response" do
      get posts_path
      expect(response).to be_successful
    end
  end

  describe "GET /posts/:id" do
    it "returns a successful response" do
      get post_path(user_post)
      expect(response).to be_successful
    end
  end

  describe "GET /posts/new" do
    it "returns a successful response when user is signed in" do
      sign_in user
      get new_post_path
      expect(response).to be_successful
    end

    it "redirects to sign in page when user is not signed in" do
      get new_post_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  describe "POST /posts" do
    context "with valid parameters" do
      it "creates a new post" do
        sign_in user
        expect {
          post posts_path, params: { post: FactoryBot.attributes_for(:post) }
        }.to change(Post, :count).by(1)
      end
    end

    context "with invalid parameters" do
      it "does not create a new post" do
        sign_in user
        expect {
          post posts_path, params: { user_post: { title: nil, content: "Test Content"} }
        }.to_not change(Post, :count)
      end
    end
  end

  describe "GET /posts/:id/edit" do
    it "returns a successful response" do
      sign_in user
      get edit_post_path(user_post)
      expect(response).to be_successful
    end
  end

  describe "PATCH /posts/:id" do
    context "with valid parameters" do
      it "updates the post" do
        sign_in user
        new_title = "New Title"
        patch post_path(user_post), params: { post: { title: new_title } }
        user_post.reload
        expect(user_post.title).to eq(new_title)
      end
    end

    context "with invalid parameters" do
      it "does not update the post" do
        sign_in user
        patch post_path(user_post), params: { user_post: { title: nil } }
        user_post.reload
        expect(user_post.title).to_not be_nil
      end
    end
  end

  describe "DELETE /posts/:id" do
    it "deletes the post" do
      sign_in user
      user_post
      expect {
        delete post_path(user_post)
      }.to change(Post, :count).by(-1)
    end
  end

  # Test without mokcing
  describe "Real data tests" do
    it "creates a new post for the user and returns a successful response" do
      # Creating a new user
      new_user = User.create!(email: 'user@example.com', password: 'password')
      new_user.save!

      # Creating a new post
      post = Post.new(title: 'Test Post', content: 'Test Description', user_id: new_user.id)

      post.save!

      sign_in new_user
      get post_path(post)
      expect(response).to be_successful
    end
  end
end
