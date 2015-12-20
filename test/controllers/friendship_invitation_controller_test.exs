defmodule FacebookClone.FriendshipInvitationControllerTest do
  use FacebookClone.ConnCase

  alias FacebookClone.TestHelper

  alias FacebookClone.FriendshipInvitation
  alias FacebookClone.Friendship
  alias FacebookClone.Repo

  setup do
    {:ok, user} = TestHelper.create_user("foo@bar.com")
    {:ok, other_user} = TestHelper.create_user("foo2@bar.com")

    session_params =
      %{"session": %{"email": user.email, "password": "password"}}

    conn = post conn(), "/login", session_params

    invitation = FriendshipInvitation.changeset(%FriendshipInvitation{}, %{
      user_id: other_user.id,
      invited_id: user.id
    })
    {:ok, invitation} = Repo.insert(invitation)

    inv_count = Repo.all(FriendshipInvitation) |> Enum.count

    {:ok,
      conn: conn,
      user: user,
      other_user: other_user,
      invitation: invitation,
      inv_count: inv_count
    }
  end

  test "POST /friendship_invitations with valid params",
       %{conn: conn, inv_count: count} do

    {:ok, other_user} = TestHelper.create_user("foo3@bar.com")
    params = %{invited_id: "#{other_user.id}"}
    conn = post conn, "/friendship_invitations", friendship_invitation: params

    assert get_flash(conn)["info"] == "User has been invited to your friends"
    assert Repo.all(FriendshipInvitation) |> Enum.count == count + 1
  end

  test "POST /friendship_invitations with invalid params",
       %{conn: conn, other_user: other_user, inv_count: count} do
    params = %{invited_id: "#{other_user.id + 999}"}
    conn = post conn, "/friendship_invitations", friendship_invitation: params

    assert get_flash(conn)["info"] == "User does not exist"
    assert Repo.all(FriendshipInvitation) |> Enum.count == count
  end

  test "PUT /friendship_invitations with valid params",
       %{conn: conn, other_user: other_user, invitation: invitation, inv_count: count} do
    conn = put conn, "/friendship_invitations/#{invitation.id}"

    assert get_flash(conn)["info"] == "Friendship invitation accepted"
    assert Repo.all(FriendshipInvitation) |> Enum.count == count - 1
    assert Repo.all(Friendship) |> Enum.count == 2
  end

  test "PUT /friendship_invitations with invalid params",
       %{conn: conn, user: user, inv_count: count} do
    {:ok, other_user} = TestHelper.create_user("foo3@bar.com")
    invitation = FriendshipInvitation.changeset(%FriendshipInvitation{}, %{
      user_id: user.id,
      invited_id: other_user.id
    })
    {:ok, invitation} = Repo.insert(invitation)

    conn = put conn, "/friendship_invitations/#{invitation.id}"

    assert Repo.all(FriendshipInvitation) |> Enum.count == count + 1
    assert Repo.all(Friendship) |> Enum.count == 0
  end
end
