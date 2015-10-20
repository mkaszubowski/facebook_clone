defmodule FacebookClone.RegistrationControllerTest do
  use FacebookClone.ConnCase

  test "GET /register" do
    conn = get conn(), "/register"
    assert html_response(conn, 200) =~ "Register new account"
    assert html_response(conn, 200) =~ ~r/<form.*register.*>/
  end
end
