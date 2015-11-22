defmodule FacebookClone.FriendshipInvitationTest do
  use FacebookClone.ModelCase

  alias FacebookClone.FriendshipInvitation
  alias FacebookClone.Repo

  alias FacebookClone.TestHelper

  setup do
    {:ok, user1} = TestHelper.create_user("foo-1@bar.com", "password")
    {:ok, user2} = TestHelper.create_user("foo-2@bar.com", "password")

    {:ok, user1: user1, user2: user2}
  end

  test "is invalid without both users' ids", context do
    changeset = FriendshipInvitation.changeset(%FriendshipInvitation{}, %{
      user_id: nil,
      invited_id: context[:user2].id})

    refute changeset.valid?

    changeset = FriendshipInvitation.changeset(%FriendshipInvitation{}, %{
      user_id: context[:user1].id,
      invited_id: nil})

    refute changeset.valid?
  end

    test "does not show database error user id is invalid" do
    {:ok, user} = TestHelper.create_user("foo@bar.com", "password")

    changeset = FriendshipInvitation.changeset(%FriendshipInvitation{}, %{
      user_id: user.id,
      invited_id: user.id + 1})

    {status, _changeset} = Repo.insert(changeset)

    assert status == :error

    changeset = FriendshipInvitation.changeset(%FriendshipInvitation{}, %{
      user_id: user.id + 1,
      invited_id: user.id})
    {status, _changeset} = Repo.insert(changeset)

    assert status == :error
  end

  test "user can have many friendships", context do
    changeset = FriendshipInvitation.changeset(%FriendshipInvitation{}, %{
      user_id: context[:user1].id,
      invited_id: context[:user2].id})
    Repo.insert(changeset)

    {:ok, user3} = TestHelper.create_user("foo-3@bar.com", "password")
    changeset = FriendshipInvitation.changeset(%FriendshipInvitation{}, %{
      user_id: context[:user1].id,
      invited_id: user3.id})

    {status, _changeset} = Repo.insert(changeset)

    assert status == :ok
  end

  test "is invalid is users' ids combination is not unique", context do
    changeset = FriendshipInvitation.changeset(%FriendshipInvitation{}, %{
      user_id: context[:user1].id,
      invited_id: context[:user2].id})
    Repo.insert!(changeset)

    {status, _changeset} = Repo.insert(changeset)

    assert status == :error
  end

  test "belongs_to users association", %{user1: user1, user2: user2} do
    changeset = FriendshipInvitation.changeset(%FriendshipInvitation{}, %{
      user_id: user1.id,
      invited_id: user2.id})
    Repo.insert!(changeset)

    friendship =
      Repo.all(from f in FriendshipInvitation, preload: [:user, :invited])
      |> Enum.at(0)

    assert friendship.user.id == user1.id
    assert friendship.invited.id == user2.id
  end

end
