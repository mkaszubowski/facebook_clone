defmodule FacebookClone.UserControllerTest do
  use FacebookClone.ConnCase

  import Mock

  alias FacebookClone.SessionHandler
  alias FacebookClone.TestHelper

  setup do
    users =
      1..10
      |> Enum.map(fn(x) -> TestHelper.create_user("foo-#{x}@bar.com", "password", "Foo-#{x}", "Bar-#{x}") end)
      |> Enum.map(fn(x) -> elem(x, 1) end)

    {:ok, users: users}
  end


  test "GET /users", context do
    with_mock SessionHandler, mock_user_params do
      conn = get conn(), "/users"

      context[:users]
      |> Enum.each(fn(user) -> assert conn.resp_body =~ user.first_name end)
    end
  end

  test "GET /users/:id/edit" do
    {:ok, user} =
      TestHelper.create_user("foo@bar.com", "password", "Foo", "Bar")

    with_mock SessionHandler, mock_user_params(user) do
      conn = get conn(), "/users/#{user.id}/edit"

      assert html_response(conn, 200) =~ "Edit your profile"
      assert html_response(conn, 200) =~ ~r/<form.*users.*>/
    end
  end

  defp mock_user_params(user \\ true) do
    [
      logged_in?: fn(_conn) -> true end,
      current_user: fn(_conn) -> user end
    ]
  end
end
