defmodule FacebookClone.UserTest do
  use FacebookClone.ModelCase

  alias FacebookClone.User
  alias FacebookClone.Repo
  alias FacebookClone.Friendship

  @valid_attrs %{ email: "foo@bar.com", password: "foobar123", first_name: "Foo", last_name: "Bar"}
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

    new_changeset = User.changeset(%User{}, @valid_attrs)

    {:error, new_changeset} = Repo.insert(new_changeset)

    error = new_changeset.errors |> List.first
    error_msg = elem(error, 1)
    assert error_msg =~ "taken"
  end

  test "password has to be at least 6 characters long" do
    changeset = User.changeset(%User{}, %{@valid_attrs | password: "12345"})

    refute changeset.valid?
  end

  test "first name is required" do
    changeset = User.changeset(%User{}, Map.delete(@valid_attrs, :first_name))

    refute changeset.valid?
  end

  test "last name is required" do
    changeset = User.changeset(%User{}, Map.delete(@valid_attrs, :last_name))

    refute changeset.valid?
  end

  test "is invalid when gender is not in (0, 1)" do
    changeset = User.changeset(%User{}, %{email: "foo@bar.com", password: "foobar123", gender: 2})

    refute changeset.valid?
  end

  test "friendships association" do
    {_user, _user2, friendship} = create_friendship

    user = Repo.all(from u in User, preload: [:friendships]) |> Enum.at(0)
    assert user.friendships |> Enum.at(0) == friendship
  end

  test "friends association" do
    {_user, user2, _friendship} = create_friendship

    user = Repo.all(from u in User, preload: [:friends]) |> Enum.at(0)
    assert (user.friends |> Enum.at(0)).id == user2.id
  end

  defp create_friendship do
    changeset = User.changeset(%User{}, @valid_attrs)
    user = Repo.insert!(changeset)
    changeset2 = User.changeset(%User{}, %{@valid_attrs | email: "foo2@bar.com"})
    user2 = Repo.insert!(changeset2)

    friendship_changeset = Friendship.changeset(
      %Friendship{}, %{user_one_id: user.id, user_two_id: user2.id})
    friendship = Repo.insert!(friendship_changeset)

    {user, user2, friendship}
  end
end
