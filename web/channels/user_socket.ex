defmodule FacebookClone.UserSocket do
  use Phoenix.Socket

  alias Phoenix.Token
  alias FacebookClone.{Repo, User, Conversation}

  ## Channels
  channel "conversations:*", FacebookClone.ConversationChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket
  # transport :longpoll, Phoenix.Transports.LongPoll

  def connect(params, socket) do
    case Token.verify(socket, "user", params["token"], max_age: 1209600) do
      {:ok, user_id} ->
        socket = assign_user(socket, user_id)

        case Token.verify(socket, "conversation", params["conversation"]) do
          {:ok, conversation_id} ->
            socket = assign_conversation(socket, conversation_id)
          {:error, _} ->
        end

        {:ok, socket}
      {:error, _} ->
        :error
    end
  end

  defp assign_user(socket, user_id) do
    assign(socket, :user, Repo.get!(User, user_id))
  end

  defp assign_conversation(socket, conversation_id) do

    conversation =
      Repo.get!(Conversation, conversation_id)
      |> Repo.preload([:user_one, :user_two])

    IO.puts(inspect conversation)
    socket = assign(socket, :conversation, conversation)
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "users_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     FacebookClone.Endpoint.broadcast("users_socket:" <> user.id, "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil
end
