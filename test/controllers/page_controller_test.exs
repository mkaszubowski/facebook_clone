defmodule FacebookClone.PageControllerTest do
  use FacebookClone.ConnCase

  test "homepage displays 'register' link" do
    conn = get conn(), "/"

    assert html_response(conn, 200) =~ "Register"
  end
end
