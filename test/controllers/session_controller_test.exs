defmodule FacebookClone.SessionControllerTest do
  use FacebookClone.ConnCase

  alias FacebookClone.User
  alias FacebookClone.TestHelper

  test "GET /login" do
    conn = get conn(), "/login"

    assert html_response(conn, 200) =~ "Login"
  end

  test "POST /login with valid data sets correct flash message" do
    conn = TestHelper.log_in_user
    assert get_flash(conn)["info"] |> String.downcase =~ "logged in"
  end

  test "POST /login with valid data redirects to the root path" do
    conn = TestHelper.log_in_user
    assert redirected_to(conn) == "/"
  end

  test "POST /login with valid data saves current user's id in cookie" do
    conn = TestHelper.log_in_user
    user_id = FacebookClone.Repo.get_by(User, email: "foo@bar.com").id

    assert get_session(conn, "current_user") == user_id
  end

  test "POST /login with invalid data display correct flash message" do
    params =
      %{"session": %{"email": "invalid", "password": "invalid"}}
    conn = post conn(), "/login", params
    assert html_response(conn, 200) =~ "Wrong email or password"
  end

  test "DELETE /logout erases current_user info from cookies" do
    conn = TestHelper.log_in_user
    conn = delete conn, "/logout"

    refute get_session(conn, "current_user")
  end

  test "DELETE /logout sets correct flash" do
    conn = TestHelper.log_in_user
    conn = delete conn, "/logout"

    assert get_flash(conn)["info"] =~ "logged out"
  end

  test "DELETE /logout redirects to root path" do
    conn = TestHelper.log_in_user
    conn = delete conn, "/logout"

    assert redirected_to(conn) == "/"
  end
end
