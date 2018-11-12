defmodule Spotify do
  use OAuth2.Strategy

  # Public API

  def client do
    IO.puts("Got to spotify ex client public API")
    OAuth2.Client.new([
      strategy: __MODULE__,
      client_id: System.get_env("SPOTIFY_CLIENT_ID"),
      client_secret: System.get_env("SPOTIFY_CLIENT_SECRET"),
      redirect_uri: "http://localhost:4000/auth/callback",
      site: "https://api.spotify.com",
      authorize_url: "https://spotify.com/login/oauth/authorize",
      token_url: "https://spotify.com/login/oauth/access_token"
    ])
  end

  def authorize_url! do
    OAuth2.Client.authorize_url!(client(), scope: "user-read-private")
  end

  # you can pass options to the underlying http library via `opts` parameter
  def get_token!(params \\ [], headers \\ [], opts \\ []) do
    OAuth2.Client.get_token!(client(), params, headers, opts)
  end

  # Strategy Callbacks

  def authorize_url(client, params) do
    OAuth2.Strategy.AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_param(:client_secret, client.client_secret)
    |> put_header("accept", "application/json")
    |> OAuth2.Strategy.AuthCode.get_token(params, headers)
  end
end
