defmodule FacebookClone.Conversation do
  use FacebookClone.Web, :model

  alias FacebookClone.User
  alias FacebookClone.Conversation

  schema "conversations" do
    field :name, :string

    timestamps

    belongs_to :user_one, User
    belongs_to :user_two, User
  end

  @required_fields ~w(user_one_id user_two_id)
  @optional_fields ~w(name)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def for_user(user) do
    Conversation
    |> join(:inner, [c], u1 in User, c.user_one_id == u1.id)
    |> join(:inner, [c], u2 in User, c.user_two_id == u2.id)
    |> preload([:user_one, :user_two])
    |> order_by(desc: :updated_at)
  end
end
