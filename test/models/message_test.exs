defmodule FacebookClone.FriendshipTest do
  use FacebookClone.ModelCase

  alias FacebookClone.Repo
  alias FacebookClone.Conversation
  alias FacebookClone.Message

  alias FacebookClone.TestHelper

  setup do
    {:ok, user} = TestHelper.create_user("foo-1@bar.com")
    {:ok, user2} = TestHelper.create_user("foo-2@bar.com")

    conversation = Conversation.changeset(%Conversation{}, %{
      user_one_id: user.id,
      user_two_id: user2.id
    })

    conversation = Repo.insert!(conversation)

    {:ok, user: user, conversation: conversation}
  end

  test "is invalid without user id", %{user: user, conversation: conversation} do
    changeset = Message.changeset(%Message{}, %{
      user_id: user.id,
      conversation_id: conversation.id,
      content: "message"
    })
    assert changeset.valid?

    changeset = Message.changeset(%Message{}, %{
      conversation_id: conversation.id,
      content: 'message'
    })
    refute changeset.valid?
  end
end
