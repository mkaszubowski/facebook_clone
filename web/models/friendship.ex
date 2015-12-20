defmodule FacebookClone.Friendship do
  use FacebookClone.Web, :model

  alias FacebookClone.User
  alias FacebookClone.Repo
  alias FacebookClone.Friendship

  schema "friendships" do
    belongs_to :user, User
    belongs_to :friend, User

    timestamps
  end

  @required_fields ~w(user_id friend_id)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, [])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:friend_id, message: "User does not exist")
    |> unique_constraint(:user_id_friend_id,
                         message: "User is already your friend")
  end

  def delete_with_reversed(friendship) do
    reversed = reversed_friendship(friendship)

    Repo.transaction(fn ->
      {:ok, _} = Repo.delete(friendship)

      unless is_nil(reversed),
      do: {:ok, _} = Repo.delete(reversed)
    end)
  end

  defp reversed_friendship(friendship) do
    Friendship
    |> where(user_id: ^friendship.friend_id)
    |> where(friend_id: ^friendship.user_id)
    |> Repo.one
  end
end
