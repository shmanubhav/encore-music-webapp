# Used Reference: https://github.com/NatTuck/oauth2_example/blob/master/web/controllers/auth_controller.ex
defmodule LasWeb.AuthController do
  use LasWeb, :controller

  #alias LasWeb.User

  @doc """
  This action is reached via `/auth/:provider` and redirects to the OAuth2 provider
  based on the chosen strategy.
  """
  def index(conn, %{"provider" => provider}) do
    IO.puts(provider)
    redirect conn, external: authorize_url!(provider)
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> redirect(to: "/")
  end

  @doc """
  This action is reached via `/auth/:provider/callback` is the the callback URL that
  the OAuth2 provider will redirect the user back to with a `code` that will
  be used to request an access token. The access token will then be used to
  access protected resources on behalf of the user.
  """
  def callback(conn, %{"provider" => provider, "code" => code}) do
    IO.puts("CALLBACK ")
    IO.inspect(code)
    # Exchange an auth code for an access token
    client = get_token!(provider, code)
    IO.inspect(client)
    # Request the user's data with the access token
    user = get_user!(provider, client)

    IO.inspect(user)
    # TODO implement
    #User.insert_or_update(user)

    # Store the token in the "database"

    # Store the user in the session under `:current_user` and redirect to /.
    # In most cases, we'd probably just store the user's ID that can be used
    # to fetch from the database. In this case, since this example app has no
    # database, I'm just storing the user map.
    #
    # If you need to make additional resource requests, you may want to store
    # the access token as well.
    conn
    |> put_session(:current_user, user)
    |> put_session(:access_token, client.token.access_token)
    |> redirect(to: "/")
  end

  defp authorize_url!("spotify") do
    Spotify.authorize_url!()
  end

  defp authorize_url!(_) do
    raise "No matching provider available"
  end

  defp get_token!("spotify", code) do
    #IO.puts("Auth Configu Get_token calling spotify's get token passing in code")
    Spotify.get_token!(code)
  end

  defp get_token!(_, _) do
    raise "No matching provider available"
  end

  defp get_user!("spotify", client) do
    IO.inspect(client)
    %{body: user} = OAuth2.Client.get!(client, "/user")
    %{name: user["name"], avatar: user["avatar_url"], token: client.token.access_token}
  end

end
