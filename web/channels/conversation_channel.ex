defmodule FacebookClone.ConversationChannel do
  use Phoenix.Channel

  alias FacebookClone.{Repo, Message}

  def join("conversations:general", message, socket) do
    {:ok, socket}
  end

  def handle_in("new:message", message, socket) do
    IO.puts(inspect socket)

    save_message(socket, message)

    # user = socket.conversation.
    broadcast!(socket, "new:message", %{
      content: message["content"],
      user: FacebookClone.UserView.full_name(socket.assigns.user)
    })

    {:noreply, socket}
  end

  defp save_message(socket, message) do
    %Message{
      content:   message["content"],
      user_id: socket.assigns.user.id,
      conversation_id: socket.assigns.conversation.id
    } |> Repo.insert!
  end
end
