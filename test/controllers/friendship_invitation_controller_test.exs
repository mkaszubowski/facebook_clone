defmodule FacebookClone.FriendshipInvitationControllerTest do
  use FacebookClone.ConnCase

  alias FacebookClone.TestHelper

  alias FacebookClone.FriendshipInvitation
  alias FacebookClone.Repo

  setup do
    {:ok, user} = TestHelper.create_user("foo@bar.com")
    {:ok, other_user} = TestHelper.create_user("foo2@bar.com")

    session_params =
      %{"session": %{"email": user.email, "password": "password"}}

    conn = post conn(), "/login", session_params

    {:ok, conn: conn, user: user, other_user: other_user}
  end

  test "POST /friendship_invitations with valid params",
       %{conn: conn, other_user: other_user} do
    params = %{invited_id: "#{other_user.id}"}
    conn = post conn, "/friendship_invitations", friendship_invitation: params

    assert get_flash(conn)["info"] == "User has been invited to your friends"
    assert Repo.all(FriendshipInvitation) |> Enum.count == 1
  end

  test "POST /friendship_invitations with invalid params",
       %{conn: conn, other_user: other_user} do
    params = %{invited_id: "#{other_user.id + 1}"}
    conn = post conn, "/friendship_invitations", friendship_invitation: params

    assert get_flash(conn)["info"] == "User does not exist"
    assert Repo.all(FriendshipInvitation) |> Enum.count == 0
  end
end
