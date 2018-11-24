# Used Reference: https://github.com/NatTuck/oauth2_example/blob/master/web/controllers/auth_controller.ex
defmodule LasWeb.AuthController do
  use LasWeb, :controller

  alias LasWeb.Users

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

    # Request the user's spotify data with the access token
    user = get_user!(provider, client)

    login_user = get_session(conn, :current_login_user)

    # Store the token in the database
    Las.Users.update_user(login_user, %{token: client.token.access_token})

    # If you need to make additional resource requests, you may want to store
    # the access token as well.
    conn
    |> put_session(:current_user, user)
    |> put_session(:access_token, client.token.access_token)
    # TODO: Possibly fix this
    |> redirect(to: "/explore")
  end

  def callback(conn, %{"provider" => provider}) do
    party_name = get_session(conn, :party_name)
    conn
    |> redirect(to: "/party/#{party_name}")
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
