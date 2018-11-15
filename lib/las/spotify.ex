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
    OAuth2.Client.authorize_url!(client(), scope: "playlist-modify-public user-modify-playback-state user-read-recently-played")
  end

  # you can pass options to the underlying http library via `opts` parameter
  def get_token!(params \\ [], headers \\ [], opts \\ []) do
    IO.puts("In spotify.ex get token")
    OAuth2.Client.get_token!(client(), params, headers, opts)
  end



# FROM THE API DOCS
# https://developer.spotify.com/documentation/general/guides/authorization-guide/#authorization-code-flow
# REQUEST BODY PARAMETER	VALUE
# grant_type	Required.
# As defined in the OAuth 2.0 specification, this field must contain the value "authorization_code".
# code	Required.
# The authorization code returned from the initial request to the Account /authorize endpoint.
# redirect_uri	Required.
# This parameter is used for validation only (there is no actual redirection). The value of this parameter must exactly match the value of redirect_uri supplied when requesting the authorization code.
# HEADER PARAMETER	VALUE
# Authorization	Required.
# Base 64 encoded string that contains the client ID and client secret key. The field must have the format: Authorization: Basic *<base64 encoded client_id:client_secret>*
# *** An alternative way to send the client id and secret is as request parameters (client_id and client_secret) in the POST body, instead of sending them base64-encoded in the header.

  # def idk(params) do
  #   "grant_type=authorization_code&code=#{params}&redirect_uri=#{client().redirect_uri}" #|> Poison.encode!
  # end
  #
  # def post_body(params) do
  # %{
  #   "code" => params,
  #   "grant_type" => "authorization_code",
  #   "redirect_uri" => client().redirect_uri,
  #   # "client_id"=> client().client_id,
  #   # "client_secret" => client().client_secret
  # } #|> URI.encode_query
  # end

  # def idk3(params) do
  #   body =
  #    %{
  #      grant_type: "authorization_code",
  #      code: params,
  #      redirect_uri: client().redirect_uri,
  #      client_id: client().client_id,
  #      client_secret: client().client_secret
  #    } |> URI.encode_query
  #    body
  # end
  #
  # def idk2(params) do
  #   %{
  #     grant_type: "authorization_code",
  #     code: params,
  #     redirect_uri: client().redirect_uri
  #    } |> URI.encode_query # Poison.encode!()
  # end

  #
  # def body(code) do
  #
  #   body = Poison.encode!(%{
  #
  #     "param": [
  #         %{
  #           "code": code,
  #           "grant_type": "authorization_code",
  #           "redirect_uri": client().redirect_uri
  #         }
  #       ]
  #     # params: {
  #     #
  #     # }
  #     # "code": code,
  #     # "grant_type": "authorization_code",
  #     # "redirect_uri": client().redirect_uri
  #   })
  #   body
  #
  #   # [
  #   #   {"code", code},
  #   #   {"grant_type", "authorization_code"},
  #   #   {"redirect_uri", client().redirect_uri},
  #   #   # {:client_id, client().client_id},           # This can also get sent in as header params
  #   #   # {:client_secret, client().client_secret}    # This can also get sent in as header params
  #   # ]
  # end

  # def headerFormat do
  #   [
  #   #  {"Authorization", "Basic #{encoded_credentials()}"},
  #     {"Content-Type", "application/x-www-form-urlencoded"}
  #   ]
  # end
  #
  # def headerFormat1 do
  #   %{
  #     "Authorization"=> "Basic #{encoded_credentials()}",
  #   "Content-Type"=> "application/x-www-form-urlencoded"
  #   }

    # }
    #   {"Authorization", "Basic #{encoded_credentials()}"},
    #   {"Content-Type", "application/x-www-form-urlencoded"}
    # ]
  # end

  # # If we want to send client id and secret in 64 bit encoded in the header params
  # def encoded_credentials do
  #   Base.encode64("#{client().client_id}:#{client().client_secret}")
  # end
  #   #base64.encode("#{client().client_id}:#{client().client_secret}")

  # Strategy Callbacks

  def authorize_url(client, params) do
    OAuth2.Strategy.AuthCode.authorize_url(client, params)
  end

  def get_token(client, params, headers) do
    client
    |> put_param(:client_secret, client.client_secret)
    |> put_header("accept", "application/json")
    #|> put_header("Authorization", "Basic #{encoded_credentials()}")
    |> OAuth2.Strategy.AuthCode.get_token(params, headers)
  end
end
