defmodule FacebookClone.ConversationUser do
  use FacebookClone.Web, :model

  alias FacebookClone.User
  alias FacebookClone.Conversation

  schema "conversations" do
    timestamps

    has_many :conversation_users, ConversationUser
    belongs_to :conversation, Conversation
  end

  @required_fields ~w(user_id conversation_id)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, [])
    |> foreign_key_constraint(:user_id, message: "User does not exist")
    |> foreign_key_constraint(:conversation_id,
          message: "Conversation does not exist")
    |> unique_constraint(:user_id_conversation_id,
          message: "You've already joined this conversation")
  end
end
