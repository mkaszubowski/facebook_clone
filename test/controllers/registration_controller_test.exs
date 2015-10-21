defmodule FacebookClone.RegistrationControllerTest do
  use FacebookClone.ConnCase

  defp send_create_request do
    params = ["user": %{email: "foo@bar.com", password: "password"}]
    post conn(), "/register", params
  end

  test "GET /register" do
    conn = get conn(), "/register"
    assert html_response(conn, 200) =~ "Register new account"
    assert html_response(conn, 200) =~ ~r/<form.*register.*>/
  end

  test "POST /register with correct params creates an user" do
    assert FacebookClone.Repo.all(FacebookClone.User) |> Enum.count == 0

    conn = send_create_request

    assert FacebookClone.Repo.all(FacebookClone.User) |> Enum.count == 1
  end

  test "POST /register with valid params has a corrent status code" do
    conn = send_create_request
    assert conn.status == 302
  end

  test "POST /register with valid params sets a correct flash message" do
    conn = send_create_request
    assert get_flash(conn)["info"] == "User created"
  end

  test "POST /register with valid params redirects to root path" do
    conn = send_create_request
    assert redirected_to(conn) == "/"
  end
end
