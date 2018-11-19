# Used Reference: https://github.com/NatTuck/oauth2_example/blob/master/web/controllers/auth_controller.ex
defmodule LasWeb.AuthController do
  use LasWeb, :controller

  #alias LasWeb.User

  @doc """
  This action is reached via `/auth/:provider` and redirects to the OAuth2 provider
  based on the chosen strategy.
  """
  def index(conn, %{"provider" => provider}) do
    redirect conn, external: authorize_url!(provider)
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> configure_session(drop: true)
    |> delete_session(:assign_current_login_user)
    |> redirect(to: "/")
  end

  @doc """
  This action is reached via `/auth/:provider/callback` is the the callback URL that
  the OAuth2 provider will redirect the user back to with a `code` that will
  be used to request an access token. The access token will then be used to
  access protected resources on behalf of the user.
  """
  def callback(conn, %{"provider" => provider, "code" => code}) do
    # Exchange an auth code for an access token
    client = get_token!(provider, code)

    # Request the user's data with the access token
    # This means we can get back their data
    user = get_user!(provider, client)
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
    # TODO: Possibly fix this
    |> redirect(to: "/explore")
  end

  defp authorize_url!("spotify") do
    Spotify.authorize_url!()
  end

  defp authorize_url!(_) do
    raise "No matching provider available"
  end

  defp get_token!("spotify", code) do
    Spotify.get_token!(code: code)
  end

  defp get_token!(_, _) do
    raise "No matching provider available"
  end

  defp get_user!("spotify", client) do
    %{body: user} = OAuth2.Client.get!(client, "/v1/me")
    %{name: user["display_name"], spotify_url: user["external_urls"]["spotify"], token: client.token.access_token, followers: user["followers"]["total"]}
  end

end
