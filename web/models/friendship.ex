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

  after_delete :delete_reversed_friendship

  @required_fields ~w(user_id friend_id)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, [])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:friend_id, message: "User does not exist")
    |> unique_constraint(:user_id_friend_id,
                         message: "User is already your friend")
  end


  defp delete_reversed_friendship(changeset) do
    reversed_friendship = Repo.get_by(Friendship, %{
      user_id: changeset.model.friend_id,
      friend_id: changeset.model.user_id
    })

    unless is_nil(reversed_friendship) do
      Repo.delete!(reversed_friendship)
    end

    changeset
  end
end
