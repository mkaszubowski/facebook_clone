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

    params = %{
      "friendship": %{
        user_one_id: user.id,
        user_two_id: user2.id
      }
    }

    conn = post conn, "/friendships", params

    friendship = Repo.all(Friendship) |> Enum.at(0)

    assert get_flash(conn)["info"] == "User has been invited to your friends"
    assert friendship.user_one_id == user.id
  end
end
