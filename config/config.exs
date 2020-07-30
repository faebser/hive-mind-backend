# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :hive_backend,
  ecto_repos: [HiveBackend.Repo]

# Configures the endpoint
config :hive_backend, HiveBackendWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "7j39fmyFU55vhLrtTBuH/+U3Cpr6vaQ1MtHITLOIuPIOXIxHnxQs3Oevt1cFT8qW",
  render_errors: [view: HiveBackendWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: HiveBackend.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :tesla, adapter: Tesla.Adapter.Hackney

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
