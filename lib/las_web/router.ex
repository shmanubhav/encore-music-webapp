# Used Reference: https://github.com/scrogson/oauth2_example/blob/master/web/router.ex

defmodule LasWeb.Router do
  use LasWeb, :router

  pipeline :browser do
    plug :accepts, ["html", "js"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :assign_current_user
    plug :assign_current_login_user

  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", LasWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/login", PageController, :login
    resources "/rooms", RoomController
    resources "/users", UserController
    resources "/songs", SongController
    resources "/sessions", SessionController, only: [:create, :delete], singleton: true
  end

  scope "/auth", LasWeb do
    pipe_through :browser

    get "/:provider", AuthController, :index
    get "/:provider/callback", AuthController, :callback
    delete "/logout", AuthController, :delete
  end

  # Fetch the current user from the session and add it to `conn.assigns`. This
  # will allow you to have access to the current user in your views with
  # `@current_user`.
  defp assign_current_user(conn, _) do
    assign(conn, :current_user, get_session(conn, :current_user))
  end

  # Fetch the current login user from the session and add it to `conn.assigns`. This
  # will allow you to have access to the current login user in your views with
  # `@current_login_user`.
  # We do this in order to distinguish the login user (user to our site) with the
  # Spotify logged in user, since a user has to login to our app and then also login
  # to Spotify as well.
  defp assign_current_login_user(conn, _) do
    assign(conn, :current_login_user, get_session(conn, :current_login_user))
  end

  # Other scopes may use custom stacks.
  # scope "/api", LasWeb do
  #   pipe_through :api
  # end
end
