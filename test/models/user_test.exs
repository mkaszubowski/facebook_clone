defmodule FacebookClone.UserTest do
  use FacebookClone.ModelCase

  alias FacebookClone.User
  alias FacebookClone.Repo
  alias FacebookClone.Friendship
  alias FacebookClone.TestHelper

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

  test "friends query" do
    {:ok, user1} = TestHelper.create_user("foo1@bar.com", "password")
    {:ok, user2} = TestHelper.create_user("foo2@bar.com", "password")
    {:ok, user3} = TestHelper.create_user("foo3@bar.com", "password")
    {:ok, user4} = TestHelper.create_user("foo4@bar.com", "password")

    user = Repo.all(User) |> Enum.at(0)

    TestHelper.create_friendship(user1, user2, true)
    TestHelper.create_friendship(user1, user3, false)
    TestHelper.create_friendship(user4, user1, true)

    friend_ids = user |> User.friends |> Enum.map(&(&1.id))

    assert Enum.member?(friend_ids, user2.id) == true
    assert Enum.member?(friend_ids, user4.id) == true
    refute Enum.member?(friend_ids, user3.id)
  end

  test "invited_by query returns only not accepted invitations" do
    {:ok, user1} = TestHelper.create_user("foo1@bar.com", "password")
    {:ok, accepted} = TestHelper.create_user("foo2@bar.com", "password")
    {:ok, invited_by} = TestHelper.create_user("foo3@bar.com", "password")
    {:ok, invited} = TestHelper.create_user("foo4@bar.com", "password")

    {_u1, _u2, _f} = TestHelper.create_friendship(user1, accepted, true)
    {_u1, _u2, _f} = TestHelper.create_friendship(user1, invited, false)
    {_u1, _u2, _f} = TestHelper.create_friendship(invited_by, user1, false)

    user = Repo.all(User) |> Enum.at(0)

    invited_by_ids = user |> User.invited_by |> Enum.map(&(&1.id))

    refute Enum.member?(invited_by_ids, accepted.id)
    assert Enum.member?(invited_by_ids, invited_by.id) == true
    refute Enum.member?(invited_by_ids, invited.id)
  end

  test "deleting user should delete the friendship" do
    {:ok, user1} = TestHelper.create_user("foo1@bar.com", "password")
    {:ok, user2} = TestHelper.create_user("foo2@bar.com", "password")
    {:ok, user3} = TestHelper.create_user("foo3@bar.com", "password")

    TestHelper.create_friendship(user1, user2)
    TestHelper.create_friendship(user1, user3)
    assert Repo.all(Friendship) |> Enum.count == 2

    # delete user_two
    Repo.delete(user2)
    assert Repo.all(Friendship) |> Enum.count == 1

    #delete user_one
    Repo.delete(user1)
    assert Repo.all(Friendship) |> Enum.count == 0
  end
end
