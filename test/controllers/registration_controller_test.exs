defmodule FacebookClone.RegistrationControllerTest do
  use FacebookClone.ConnCase

  test "GET /register" do
    conn = get conn(), "/register"
    assert html_response(conn, 200) =~ "Register new account"
    assert html_response(conn, 200) =~ ~r/<form.*register.*>/
  end

  test "POST /register with correct params creates an user" do
    params = ["user": %{email: "foo@bar.com", password: "password"}]

    assert FacebookClone.Repo.all(FacebookClone.User) |> Enum.count == 0

    conn = post conn(), "/register", params
    assert FacebookClone.Repo.all(FacebookClone.User) |> Enum.count == 1
  end
end
