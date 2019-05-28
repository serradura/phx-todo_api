# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :todo_api,
  ecto_repos: [TodoApi.Repo]

# Configures the endpoint
config :todo_api, TodoApiWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "tGZ5HpTYZ/oQfubA7ZxmQ5RK8kKZjyPW83y9eJ0PnjxdLY6RmAjdZEcOGXOK7D1d",
  render_errors: [view: TodoApiWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: TodoApi.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
