defmodule FacebookClone.FriendshipControllerTest do
  use FacebookClone.ConnCase

  alias FacebookClone.TestHelper

  alias FacebookClone.Friendship
  alias FacebookClone.Repo

  setup do
    {:ok, user} = TestHelper.create_user("foo@bar.com", "foobar")

    session_params =
      %{"session": %{"email": user.email, "password": "foobar"}}

    conn = post conn(), "/login", session_params

    {:ok, conn: conn, user: user}
  end


  test "GET /friends displays user's friends",
    %{conn: conn, user: user} do

    {:ok, user2} = TestHelper.create_user(
      "foo-2@bar.com", "password", "Foo2", "Bar2")

    TestHelper.create_friendship(user, user2)

    conn = get conn, "/friends"

    friend_ids = conn.assigns[:friends] |> Enum.map(&(&1.id))

    assert html_response(conn, 200) =~ "Your friends"

    assert Enum.member?(friend_ids, user2.id) == true
  end

  test "GET /friends displays other user's invitations",
    %{conn: conn, user: user} do

    {:ok, user2} = TestHelper.create_user("foo-2@bar.com", "password")
    {:ok, user3} = TestHelper.create_user("foo-3@bar.com", "password")

    TestHelper.create_friendship_invitation(user2, user)
    TestHelper.create_friendship_invitation(user, user3)

    conn = get conn, "/friends"

    invited_by_ids = conn.assigns[:invited_by] |> Enum.map(&(&1.user_id))

    assert Enum.member?(invited_by_ids, user2.id) == true
    refute Enum.member?(invited_by_ids, user3.id)

    assert html_response(conn, 200) =~ "Received invitations"
  end

  test "DELETE /friendships for current user", %{conn: conn, user: user} do
    {:ok, user2} = TestHelper.create_user("foo-2@bar.com", "password")

    {_, _, friendship} = TestHelper.create_friendship(user, user2)
    TestHelper.create_friendship(user2, user)

    conn = delete conn, "/friendships/#{friendship.id}"

    assert Repo.all(Friendship) |> Enum.count == 0
    assert redirected_to(conn) == friendship_path(conn, :index)
  end

  test "DELETE /friendships for other user", %{conn: conn, user: user} do
    {:ok, user2} = TestHelper.create_user("foo-2@bar.com", "password")

    {_, _, friendship} = TestHelper.create_friendship(user2, user)

    conn = delete conn, "/friendships/#{friendship.id}"

    refute Repo.all(Friendship) |> Enum.count == 0
    assert get_flash(conn)["info"] == "You don't have access to this page"
    assert redirected_to(conn) == "/"
  end
end
