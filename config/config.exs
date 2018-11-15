# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :las,
  ecto_repos: [Las.Repo]

# Configures the endpoint
config :las, LasWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "pIVIJKwwsytBQGA2e7HaOn5u6usDuXFhcvAR+1YF3D1OfLc5BvwpXnBKqQi3qrLr",
  render_errors: [view: LasWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Las.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :oauth2, debug: true,
  serializers: %{
  "application/json" => Jason,
  "text/html" => Jason,
  "application/vnd.api+json" => Poison,
  }

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
