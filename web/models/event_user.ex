defmodule FacebookClone.EventUser do
  use FacebookClone.Web, :model

  alias FacebookClone.{User, Event}

  schema "event_users" do
    timestamps

    belongs_to :user, User
    belongs_to :event, Event
  end

  @required_fields ~w(event_id user_id)
  @optional_fields ~w()

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> foreign_key_constraint(:user_id, message: "User does not exist")
    |> foreign_key_constraint(:event_id, message: "Event does not exist")
    |> unique_constraint(:event_id_user_id,
        message: "You've already signed for this event")
  end
end
