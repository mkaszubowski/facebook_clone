defmodule FacebookClone.SessionHandlerHandlerTest do
  use FacebookClone.ModelCase
  use FacebookClone.ConnCase

  alias FacebookClone.SessionHandler
  alias FacebookClone.User
  alias FacebookClone.Repo
  alias FacebookClone.TestHelper


  @valid_attrs %{"email" => "foo@bar.com", "password" => "foobar"}
  @invalid_attrs %{"email" => "foo@bar.com", "password" => "invalid"}

  test "returns {:ok, user} when given valid email and password" do
    TestHelper.create_user("foo@bar.com", "foobar")

    {status, user} = SessionHandler.login(@valid_attrs, Repo)

    assert status == :ok
    assert user == Repo.all(User) |> Enum.at(0)
  end

  test "returns :error when given invalid email or password" do
    TestHelper.create_user("foo@bar.com", "foobar")

    status = SessionHandler.login(@invalid_attrs, Repo)

    assert status == :error
  end

  test "current_user returns signed in user" do
    {:ok, user} = TestHelper.create_user("foo@bar.com", "password")
    session_params =
      %{session: %{email: user.email, password: "password"}}

    conn = post conn(), "/login", session_params

    assert SessionHandler.current_user(conn).id == user.id
  end

  test "logged_in?" do
    conn = get conn(), "/"
    refute SessionHandler.logged_in?(conn)

    {:ok, user} = TestHelper.create_user("foo@bar.com", "password")
    session_params =
      %{session: %{email: user.email, password: "password"}}

    conn = post conn(), "/login", session_params

    assert SessionHandler.logged_in?(conn) == true
  end
end
