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
      user_id: nil,
      friend_id: context[:user2].id})
    refute changeset.valid?

    changeset = Friendship.changeset(%Friendship{}, %{
      user_id: context[:user1].id,
      friend_id: nil})
    refute changeset.valid?
  end

  test "does not show database error user id is invalid" do
    {:ok, user} = TestHelper.create_user("foo@bar.com", "password")

    changeset = Friendship.changeset(%Friendship{}, %{
      user_id: user.id,
      friend_id: user.id + 1})

    {status, _changeset} = Repo.insert(changeset)

    assert status == :error

    changeset = Friendship.changeset(%Friendship{}, %{
      user_id: user.id + 1,
      friend_id: user.id})
    {status, _changeset} = Repo.insert(changeset)

    assert status == :error
  end

  test "user can have many friendships", context do
    changeset = Friendship.changeset(%Friendship{}, %{
      user_id: context[:user1].id,
      friend_id: context[:user2].id})
    Repo.insert(changeset)

    {:ok, user3} = TestHelper.create_user("foo-3@bar.com", "password")
    changeset = Friendship.changeset(%Friendship{}, %{
      user_id: context[:user1].id,
      friend_id: user3.id})

    {status, _changeset} = Repo.insert(changeset)

    assert status == :ok
  end

  test "is invalid is users' ids combination is not unique", context do
    changeset = Friendship.changeset(%Friendship{}, %{
      user_id: context[:user1].id,
      friend_id: context[:user2].id})
    Repo.insert!(changeset)

    {status, _changeset} = Repo.insert(changeset)

    assert status == :error
  end

  test "belongs_to users association", %{user1: user1, user2: user2} do
    changeset = Friendship.changeset(%Friendship{}, %{
      user_id: user1.id,
      friend_id: user2.id})
    Repo.insert!(changeset)

    friendship =
      Repo.all(from f in Friendship, preload: [:user, :friend])
      |> Enum.at(0)

    assert friendship.user.id == user1.id
    assert friendship.friend.id == user2.id
  end

  test "deletes reveresed friendship", %{user1: user1, user2: user2} do
    changeset = Friendship.changeset(%Friendship{}, %{
      user_id: user1.id,
      friend_id: user2.id})
    friendship = Repo.insert!(changeset)

    reversed_changeset = Friendship.changeset(%Friendship{}, %{
      user_id: user2.id,
      friend_id: user1.id})
    reversed_friendship = Repo.insert!(reversed_changeset)

    assert Repo.all(Friendship) |> Enum.count == 2

    Repo.delete(friendship)

    assert Repo.all(Friendship) |> Enum.count == 0
  end
end
