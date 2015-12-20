defmodule FacebookClone.LikeTest do
  use FacebookClone.ModelCase

  alias FacebookClone.Post
  alias FacebookClone.Like
  alias FacebookClone.Repo

  alias FacebookClone.TestHelper

  setup do
    {:ok, user} = TestHelper.create_user("foo@bar.com", "password")

    post_changeset = Post.changeset(%Post{}, %{
      user_id: user.id, content: "test"})

    {:ok, post} = Repo.insert(post_changeset)

    {:ok, post: post, user: user}
  end

  test "is invalid without user id", %{post: post} do
    changeset = Like.changeset(%Like{}, %{post_id: post.id})

    refute changeset.valid?
  end

  test "is invalid without post id", %{user: user} do
    changeset = Like.changeset(%Like{}, %{user_id: user.id})

    refute changeset.valid?
  end
end
