defmodule Spotify do
  use OAuth2.Strategy

  # Public API

  def client do
    OAuth2.Client.new([
      strategy: __MODULE__,
      client_id: System.get_env("SPOTIFY_CLIENT_ID"),
      client_secret: System.get_env("SPOTIFY_CLIENT_SECRET"),
      redirect_uri: "http://localhost:4000/auth/spotify/callback/",
      site: "https://api.spotify.com",
      authorize_url: "https://accounts.spotify.com/authorize",
      token_url: "https://accounts.spotify.com/api/token"
    ])
  end

  def authorize_url! do
    OAuth2.Client.authorize_url!(client(), scope: "user-read-private")
  end

  # you can pass options to the underlying http library via `opts` parameter
  def get_token!(params \\ [], headers \\ [], opts \\ []) do
    IO.puts("In spotify.ex get token")
    #IO.inspect(Keyword.merge(params, grant_type: "authorization_code")); #, redirect_uri: client().redirect_uri, client_id: client().client_id, client_secret: client().client_secret))
    OAuth2.Client.get_token!(client(), body(params), headers, opts)
  end

  # I assume these parameters will get sent in as the request body parametesrs.
  # In this case,
  def body(code) do
    [
      {:code, code},
      {:grant_type, "authorization_code"},
      {:redirect_uri, client().redirect_uri},
      {:client_id, client().client_id},           # This can also get sent in as header params
      {:client_secret, client().client_secret}    # This can also get sent in as header params
    ]
  end

  # If we want to send client id and secret in 64 bit encoded in the header params
  # def encoded_credentials, do: :base64.encode("#{client().client_id}:#{client().client_secret}")

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
