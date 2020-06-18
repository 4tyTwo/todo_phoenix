# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :todo,
  ecto_repos: [Todo.Repo]

# Configures the endpoint
config :todo, TodoWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "7tCuKRiKU7MNx7SZxw02qwDTxY45I6jOOxHjvSE5/aLbrV6OLrh/uweKP68KGQ90",
  render_errors: [view: TodoWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Todo.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :todo, Todo.Guardian,
       issuer: "todo",
       secret_key: "0cv7KJ8+sVZ5mn3O+TI7TWb+q9RHGP+RAOhkZHAZGOnSLJjMD8KBvqlVIFtnSjy7"

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
