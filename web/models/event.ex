defmodule FacebookClone.Event do
  use FacebookClone.Web, :model

  alias FacebookClone.{User, EventUser, EventInvitation}

  schema "events" do
    field :name, :string
    field :description, :string
    field :date, Ecto.DateTime

    timestamps

    belongs_to :owner, User, foreign_key: :user_id

    has_many :event_users, EventUser, on_delete: :delete_all
    has_many :users, through: [:event_users, :user]

    has_many :invitations, EventInvitation, on_delete: :delete_all
  end

  @required_fields ~w(name user_id date)
  @optional_fields ~w(description)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> foreign_key_constraint(:user_id)
  end
end
