# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :messaging_service,
  ecto_repos: [MessagingService.Repo],
  generators: [timestamp_type: :utc_datetime, binary_id: true]

# Configures the endpoint
config :messaging_service, MessagingServiceWeb.Endpoint,
  url: [host: "localhost"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: MessagingServiceWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: MessagingService.PubSub,
  live_view: [signing_salt: "B+7jy/YR"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n$metadata",
  metadata: [:request_id, :message, :errors]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# config :messaging_service,
#   messenger: MessagingService.Messenger.DefaultMessenger

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
