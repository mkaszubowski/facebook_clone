defmodule FacebookClone.UserControllerTest do
  use FacebookClone.ConnCase, async: false

  alias FacebookClone.TestHelper

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


  test "GET /users", %{users: users, conn: conn} do
    conn = get conn, "/users"

    users
    |> Enum.each(fn(user) -> assert conn.resp_body =~ user.first_name end)
  end

  test "GET /users/:id/edit", %{conn: conn, current_user: current_user} do
    conn = get conn, "/users/#{current_user.id}/edit"

    assert html_response(conn, 200) =~ "Edit your profile"
    assert html_response(conn, 200) =~ ~r/<form.*users.*>/
  end
end
