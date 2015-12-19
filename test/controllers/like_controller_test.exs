defmodule FacebookClone.LikeControllerTest do
  use FacebookClone.ConnCase

  alias FacebookClone.TestHelper

  alias FacebookClone.Like
  alias FacebookClone.Post
  alias FacebookClone.Repo

  setup do
    {:ok, user} = TestHelper.create_user("foo@bar.com", "foobar")

    session_params =
      %{"session": %{"email": user.email, "password": "foobar"}}
    conn = post conn(), "/login", session_params

    post = Post.changeset(%Post{}, %{user_id: user.id, content: "post"})
    post = Repo.insert!(post)

    {:ok, conn: conn, user: user, post: post}
  end

  test "POST /likes with valid post id", %{conn: conn, user: user, post: post} do
    params = %{post_id: "#{post.id}", user_id: "#{user.id + 1}"}
    conn = post conn, "/likes", like: params

    assert get_flash(conn)["info"] == "You liked selected post"
    assert redirected_to(conn) == post_path(conn, :index)

    like = Repo.one(Like)

    assert like.user_id == user.id
  end

  test "POST /likes with invalid post id", %{conn: conn, post: post} do
    params = %{post_id: "#{post.id + 1}"}

    conn = post conn, "/likes", like: params

    assert get_flash(conn)["info"] == "Could not like selected post"
    assert redirected_to(conn) == post_path(conn, :index)

    like_count = Repo.all(Like) |> Enum.count

    assert like_count == 0
  end

  test "DELETE /likes", %{conn: conn, user: user, post: post} do
    {:ok, user2} = TestHelper.create_user("foo2@bar.com", "password")

    user_like = Like.changeset(%Like{}, %{user_id: user.id, post_id: post.id})
    user_like = Repo.insert!(user_like)

    other_like = Like.changeset(%Like{}, %{user_id: user2.id, post_id: post.id})
    other_like = Repo.insert!(other_like)


    conn = delete conn, "/likes/#{user_like.id}"
    assert redirected_to(conn) == post_path(conn, :index)
    assert Repo.all(Like) |> Enum.count == 1

    delete conn, "/likes/#{other_like.id}"
    assert Repo.all(Like) |> Enum.count == 1
  end
end
