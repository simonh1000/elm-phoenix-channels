# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
# uncomment if you want to use a database
# config :meep,
#   ecto_repos: [Meep.Repo]

# Configures the endpoint
config :meep, Meep.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "NeiF0LUFeCOKffYUcfCkx0qITTYlIEW2SsXflL6Zc/uere0M9EDOEnTRkbDdLXgw",
  render_errors: [accepts: ~w(html json)],
  pubsub: [name: Meep.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# Configure phoenix generators
config :phoenix, :generators,
  migration: true,
  binary_id: false
