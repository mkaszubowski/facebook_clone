defmodule FacebookClone.Conversation do
  use FacebookClone.Web, :model

  alias FacebookClone.User
  alias FacebookClone.ConversationUser

  schema "conversations" do
    field :name, :string

    timestamps

    has_many :conversation_users, ConversationUser
  end

  @required_fields ~w(name)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, [])
  end
end
