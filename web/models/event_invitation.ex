defmodule FacebookClone.EventInvitation do
  use FacebookClone.Web, :model

  alias FacebookClone.{Event, User}


  schema "event_invitations" do
    timestamps

    belongs_to :event, Event
    belongs_to :user, User
    belongs_to :invited_by, User
  end

  @required_fields ~w(event_id user_id invited_by_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> foreign_key_constraint(:event_id, message: "Event does not exist")
    |> foreign_key_constraint(:user_id, message: "User does not exist")
    |> foreign_key_constraint(:invited_by_id, message: "User does not exist")
    |> unique_constraint(:event_id_user_id_invited_by_id, message: "User is ")

  end
end
