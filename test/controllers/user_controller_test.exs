defmodule FacebookClone.UserControllerTest do
  use FacebookClone.ConnCase

  import FacebookClone.CreateUser, only: [create_user: 2]

  setup_all do
    users =
      1..10
      |> Enum.map(fn x -> create_user("foo-#{x}@bar.com", "password") end)

    {:ok, users: users}
  end

  test "GET /users", context do
    conn = get conn(), "/users/"

    assert conn.status == 302

    context[:users]
    |> Enum.each(fn user -> assert conn.body =~ user.first_name end)
  end

  test "GET /users/:id/edit" do
    {:ok, user} = create_user("foo@bar.com", "password")

    conn = get conn(), "/users/#{user.id}/edit"

    assert html_response(conn, 302) =~ "Edit your profile"
  end

  test "GET /users/:id/edit displays user edit form" do
    {:ok, user} = create_user("foo@bar.com", "password")

    conn = get conn(), "/users/#{user.id}/edit"

    assert html_response(conn, 302) =~ ~r/<form.*users.*>/
  end
end
