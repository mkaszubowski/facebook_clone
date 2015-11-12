defmodule FacebookClone.PostTest do
  use FacebookClone.ModelCase

  alias FacebookClone.Repo
  alias FacebookClone.Post
  alias FacebookClone.TestHelper

  setup do
    {:ok, user} = TestHelper.create_user("foo@bar.com", "foobar")

    {:ok, user: user}
  end

  test "changeset with valid attributes", %{user: user} do
    changeset = Post.changeset(%Post{}, %{user_id: user.id, content: "content"})
    assert changeset.valid?

    {status, _post} = Repo.insert(changeset)
    assert status == :ok
  end

  test "with non-existing user's id", %{user: user} do
    changeset = Post.changeset(
      %Post{}, %{user_id: user.id + 1, content: "content"})

    {status, _user} = Repo.insert(changeset)

    assert status == :error
  end

  test "with blank content", %{user: user} do
    changeset = Post.changeset(%Post{}, %{user_id: user.id, content: "   "})

    refute changeset.valid?
    assert [content: {"Can't be blank", [count: 1]}] == changeset.errors
  end

  test "leading blank characters of content should be removed", %{user: user} do
    changeset = Post.changeset(
      %Post{}, %{content: "   Content", user_id: user.id})

    {:ok, _} = Repo.insert(changeset)
    post = Repo.all(Post) |> Enum.at(0)

    assert post.content == "Content"
  end
end
