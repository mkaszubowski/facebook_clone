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

  test "POST /friendships", %{conn: conn, user: user} do
    {:ok, user2} = TestHelper.create_user("foo-2@bar.com", "password")

    params = %{friendship: %{user_two_id: "#{user2.id}"}}

    conn = post conn, "/friendships", params

    friendship = Repo.all(Friendship) |> Enum.at(0)

    assert get_flash(conn)["info"] == "User has been invited to your friends"
    assert friendship.user_one_id == user.id
    assert friendship.user_two_id == user2.id

    conn = post conn, "/friendships", params

    assert get_flash(conn)["info"] == "User already invited"
  end

  test "POST /friendships with invalid user id", %{conn: conn, user: user} do
    params = %{friendship: %{user_two_id: "#{user.id + 1}"}}

    conn = post conn, "/friendships", params

    assert get_flash(conn)["info"] == "User does not exist"

    assert redirected_to(conn) == user_path(conn, :index)
  end

  test "POST /friendships when not logged in" do
    {:ok, user2} = TestHelper.create_user("foo-2@bar.com", "password")
    params = %{friendship: %{user_two_id: "#{user2.id}"}}
    conn = post conn(), "/friendships", params

    assert get_flash(conn)["info"] =~ "You have to sign in"
    assert redirected_to(conn) == session_path(conn, :new)
  end

  test "GET /friends", %{conn: conn, user: user} do
    {:ok, user2} = TestHelper.create_user(
      "foo-2@bar.com", "password", "Foo2", "Bar2")
    {:ok, user3} = TestHelper.create_user(
      "foo-3@bar.com", "password", "Foo3", "Bar3")

    TestHelper.create_friendship(user, user2, true)
    TestHelper.create_friendship(user, user3, false)

    conn = get conn, "/friends"

    assert html_response(conn, 200) =~ "Your friends"
    assert html_response(conn, 200) =~ "Foo2 Bar2"
    refute html_response(conn, 200) =~ "Foo3"
  end
end
