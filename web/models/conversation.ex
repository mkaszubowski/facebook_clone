defmodule FacebookClone.Conversation do
  use FacebookClone.Web, :model

  alias FacebookClone.User
  alias FacebookClone.ConversationUser

  schema "conversations" do
    field :name, :string

    timestamps

    has_many :conversation_users, ConversationUser
    belongs_to :user_one, User
    belongs_to :user_two, User
  end

  @required_fields ~w(user_one_id user_two_id)
  @optional_fields ~w(name)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
