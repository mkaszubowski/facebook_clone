defmodule FacebookClone.Router do
  use FacebookClone.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :assign_current_user
  end

  pipeline :require_authenticated do
    plug :authenticate_logged_in
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", FacebookClone do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    get "/register", RegistrationController, :new
    post "/register", RegistrationController, :create

    get "/login", SessionController, :new
    post "/login", SessionController, :create
    delete "/logout", SessionController, :delete
  end

  scope "/", FacebookClone do
    pipe_through [:browser, :require_authenticated]

    resources "/users", UserController, only: [:index, :show, :edit, :update] do
      resources "/photos", PhotoController, only: [:new, :create, :index]
    end

    resources "/friendship_invitations", FriendshipInvitationController,
      only: [:create, :update]
    resources "/friendships/", FriendshipController, only: [:delete]
    get "/friends", FriendshipController, :index

    resources "/posts", PostController, except: [:show]
    resources "/likes", LikeController, only: [:create, :delete]

    resources "/conversations", ConversationController, only: [:index, :show, :create] do
      resources "/messages", MessageController, only: [:new, :create, :delete]
    end

    resources "/groups", GroupController
    resources "/group_users", GroupUserController, only: [:create, :delete]
  end

  defp authenticate_logged_in(conn, _) do
    case get_session(conn, :current_user_id) do
      nil ->
        conn
        |> put_flash(:info, "You have to sign in first")
        |> redirect(to: FacebookClone.Router.Helpers.session_path(conn, :new))
        |> halt
      _ ->
        conn
    end
  end

  defp assign_current_user(conn, _) do
    user_id = get_session(conn, :current_user_id)

    conn
    |> assign(:current_user_id, user_id)
    |> assign(:current_user, FacebookClone.UserController.get_by_id(user_id))
  end

  # Other scopes may use custom stacks.
  # scope "/api", FacebookClone do
  #   pipe_through :api
  # end
end
