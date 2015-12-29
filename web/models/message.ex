defmodule FacebookClone.Message do
  use FacebookClone.Web, :model

  alias FacebookClone.User
  alias FacebookClone.Conversation
  alias FacebookClone.Message

  import Ecto.Query


  schema "messages" do
    field :content, :string

    belongs_to :user, User
    belongs_to :conversation, Conversation

    timestamps
  end

  @required_fields ~w(user_id conversation_id content)

  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, [])
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:conversation_id)
  end

  def for_conversation(conversation) do
    conversation_id = conversation.id

    Message
    |> where(conversation_id: ^conversation.id)
    |> preload(:user)
    |> order_by(desc: :inserted_at)
  end
end
