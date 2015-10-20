defmodule FacebookClone.UserTest do
  use FacebookClone.ModelCase

  alias FacebookClone.User
  alias FacebookClone.Repo

  @valid_attrs %{email: "foo@bar.com", password: "foobar123"}
  @invalid_attrs %{email: "foo"}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "user with duplicate email is invalid" do
    changeset = User.changeset(%User{}, @valid_attrs)
    Repo.insert!(changeset)
    assert Repo.all(User) |> Enum.count == 1

    new_changeset = User.changeset(%User{}, %{email: "foo@bar.com", password: "foobar123"})
    {:error, new_changeset} = Repo.insert(new_changeset)

    error = new_changeset.errors |> List.first
    error_msg = elem(error, 1)
    assert error_msg =~ "taken"
  end

  test "password has to be at least 6 characters long" do
    changeset = User.changeset(%User{}, %{@valid_attrs | password: "12345"})

    refute changeset.valid?
  end

  test "first name is not required" do
    changeset = User.changeset(%User{}, Map.delete(@valid_attrs, :first_name))

    assert changeset.valid?
  end

  test "last name is not required" do
    changeset = User.changeset(%User{}, Map.delete(@valid_attrs, :last_name))

    assert changeset.valid?
  end
end
