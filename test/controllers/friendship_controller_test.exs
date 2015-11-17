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

  test "GET /friends displays invited and accepted friends",
    %{conn: conn, user: user} do

    {:ok, user2} = TestHelper.create_user(
      "foo-2@bar.com", "password", "Foo2", "Bar2")
    {:ok, user3} = TestHelper.create_user(
      "foo-3@bar.com", "password", "Foo3", "Bar3")
    {:ok, user4} = TestHelper.create_user(
      "foo-4@bar.com", "password", "Foo4", "Bar4")

    TestHelper.create_friendship(user, user2, true)
    TestHelper.create_friendship(user4, user, true)
    TestHelper.create_friendship(user, user3, false)

    conn = get conn, "/friends"

    friend_ids = conn.assigns[:friends] |> Enum.map(&(&1.id))

    assert html_response(conn, 200) =~ "Your friends"

    assert Enum.member?(friend_ids, user2.id) == true
    assert Enum.member?(friend_ids, user4.id) == true
    refute Enum.member?(friend_ids, user3.id)
  end

  test "GET /friends displays other user's invitations",
    %{conn: conn, user: user} do


    {:ok, user2} = TestHelper.create_user(
      "foo-2@bar.com", "password", "Foo2", "Bar2")


    conn = get conn, "/friends"

    assert conn.assigns == 2
    # assert html_response(conn, 200) =~ "<section id='invitations'>Invitations"
  end

  test "DELETE /friendships", %{conn: conn, user: user} do
    {:ok, user2} = TestHelper.create_user("foo-2@bar.com", "password")

    {_, _, friendship} = TestHelper.create_friendship(user, user2, true)

    conn = delete conn, "/friendships/#{friendship.id}"

    assert Repo.all(Friendship) |> Enum.count == 0
  end
end
