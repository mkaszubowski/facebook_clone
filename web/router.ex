defmodule FacebookClone.Router do
  use FacebookClone.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
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

    resources "/users", UserController, only: [:index, :show, :edit, :update]

    post "/friendships/", FriendshipController, :create
  end

  # Other scopes may use custom stacks.
  # scope "/api", FacebookClone do
  #   pipe_through :api
  # end
end
