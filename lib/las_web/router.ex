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

  # Other scopes may use custom stacks.
  # scope "/api", LasWeb do
  #   pipe_through :api
  # end
end
