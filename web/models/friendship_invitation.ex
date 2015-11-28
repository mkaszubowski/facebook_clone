defmodule FacebookClone.FriendshipInvitation do
  use FacebookClone.Web, :model

  alias FacebookClone.User
  alias FacebookClone.Repo
  alias FacebookClone.Friendship

  schema "friendship_invitations" do
    belongs_to :user, User
    belongs_to :invited, User

    timestamps
  end

  @required_fields ~w(user_id invited_id)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, [])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:invited_id, message: "User does not exist")
    |> unique_constraint(:user_id_invited_id, message: "User already invited")
  end

  def accept(invitation) do
    Repo.transaction fn ->
      user_one_id = invitation.user_id
      user_two_id = invitation.invited_id

      user_one_changeset = Friendship.changeset(%Friendship{}, %{
        user_id: user_one_id,
        friend_id: user_two_id
      })
      IO.puts(inspect user_one_changeset)
      user_two_changeset = Friendship.changeset(%Friendship{}, %{
        user_id: user_two_id,
        friend_id: user_one_id
      })

      Repo.insert!(user_one_changeset)
      Repo.insert!(user_two_changeset)
      Repo.delete!(invitation)
    end
  end
end
