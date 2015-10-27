defmodule FacebookClone.UserControllerTest do
  use FacebookClone.ConnCase

  alias FacebookClone.User
  alias FacebookClone.Repo

  import FacebookClone.CreateUser, only: [create_user: 2]


  test "GET /users/:id/edit" do
    {:ok, user} = create_user("foo@bar.com", "password")

    conn = get conn(), "/users/#{user.id}/edit"

    assert html_response(conn, 200) =~ "Edit your profile"
  end

  test "GET /users/:id/edit displays user edit form" do
    {:ok, user} = create_user("foo@bar.com", "password")

    conn = get conn(), "/users/#{user.id}/edit"

    assert html_response(conn, 200) =~ ~r/<form.*users.*>/
  end
end
