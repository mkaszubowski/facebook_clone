defmodule FacebookClone.UserControllerTest do
  use FacebookClone.ConnCase, async: false

  alias FacebookClone.TestHelper

  alias FacebookClone.Repo
  alias FacebookClone.User

  @update_params %{
    "user": %{
      "email": "new@email.com",
      "first_name": "new_name"
    }
  }

  setup do
    users =
      1..5
      |> Enum.map(fn(x) -> TestHelper.create_user("foo-#{x}@bar.com", "foobar", "Foo-#{x}", "Bar-#{x}") end)
      |> Enum.map(fn(x) -> elem(x, 1) end)

    user = Enum.at(users, 0)

    session_params =
      %{"session": %{"email": user.email, "password": "foobar"}}

    conn = post conn(), "/login", session_params

    {:ok, users: users, conn: conn, current_user: user}
  end


  test "GET /users should display all users expect the current_user",
    %{users: users, conn: conn, current_user: current_user} do

    conn = get conn, "/users"

    refute conn.resp_body =~ current_user.first_name

    users
    |> List.delete(current_user)
    |> Enum.each(fn(user) -> assert conn.resp_body =~ user.first_name end)

  end

  test "GET /users/:id/edit", %{conn: conn, current_user: current_user} do
    conn = get conn, "/users/#{current_user.id}/edit"

    assert html_response(conn, 200) =~ "Edit your profile"
    assert html_response(conn, 200) =~ ~r/<form.*users.*>/
  end

  test "PUT /users/:id for the current user",
    %{conn: conn, current_user: current_user} do

    old_email = current_user.email

    put conn, "/users/#{current_user.id}", @update_params

    user = Repo.get(User, current_user.id)

    assert user.first_name == "new_name"
    assert user.email == old_email
  end

  test "PUT /users/:id for other users", %{conn: conn, users: users} do
    not_current_user = Enum.at(users, 4)

    conn = put conn, "/users/#{not_current_user.id}", @update_params

    assert html_response(conn, 302) =~ "redirected"
    assert redirected_to(conn) == "/"
  end

  test "PUT /users/:id when not logged in" do
    {:ok, user} = TestHelper.create_user("foo@bar.com", "foobar")

    conn = put conn(), "/users/#{user.id}", @update_params

    assert html_response(conn, 302) =~ "redirected"
    assert redirected_to(conn) == "/login"
  end
end
