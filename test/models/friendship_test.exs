defmodule FacebookClone.FriendshipTest do
  use FacebookClone.ModelCase

  alias FacebookClone.Friendship
  alias FacebookClone.Repo

  alias FacebookClone.TestHelper

  setup do
    {:ok, user1} = TestHelper.create_user("foo-1@bar.com", "password")
    {:ok, user2} = TestHelper.create_user("foo-2@bar.com", "password")

    {:ok, user1: user1, user2: user2}
  end

  test "is invalid without both users' ids", context do
    changeset = Friendship.changeset(%Friendship{}, %{
      user_one_id: nil,
      user_two_id: context[:user2].id})
    refute changeset.valid?

    changeset = Friendship.changeset(%Friendship{}, %{
      user_one_id: context[:user1].id,
      user_two_id: nil})
    refute changeset.valid?
  end

  test "does not show database error user id is invalid" do
    {:ok, user} = TestHelper.create_user("foo@bar.com", "password")

    changeset = Friendship.changeset(%Friendship{}, %{
      user_one_id: user.id,
      user_two_id: user.id + 1})
    {status, _changeset} = Repo.insert(changeset)

    assert status == :error

    changeset = Friendship.changeset(%Friendship{}, %{
      user_one_id: user.id + 1,
      user_two_id: user.id})
    {status, _changeset} = Repo.insert(changeset)

    assert status == :error
  end

  test "user can have many friendships", context do
    changeset = Friendship.changeset(%Friendship{}, %{
      user_one_id: context[:user1].id,
      user_two_id: context[:user2].id})
    Repo.insert(changeset)

    {:ok, user3} = TestHelper.create_user("foo-3@bar.com", "password")
    changeset = Friendship.changeset(%Friendship{}, %{
      user_one_id: context[:user1].id,
      user_two_id: user3.id})

    {status, _changeset} = Repo.insert(changeset)

    assert status == :ok
  end

  test "is invalid is users' ids combination is not unique", context do
    changeset = Friendship.changeset(%Friendship{}, %{
      user_one_id: context[:user1].id,
      user_two_id: context[:user2].id})
    Repo.insert!(changeset)

    {status, _changeset} = Repo.insert(changeset)

    assert status == :error
  end

  test "accepted attribute defaults to false", context do
    changeset = Friendship.changeset(%Friendship{}, %{
      user_one_id: context[:user1].id,
      user_two_id: context[:user2].id})
    {:ok, friendship} = Repo.insert(changeset)

    refute friendship.accepted
  end
end
