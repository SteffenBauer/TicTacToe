# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :ttt_server, TttServer.Endpoint,
  url: [host: "localhost"],
  http: [port: System.get_env("PORT")],
  secret_key_base: "8cbXwjUoGC9ghA2tLchHjMervDw0cAEyIuit1isSiXE6aBsJncO8XJ2l2G6BIquG",
  debug_errors: false

config :phoenix, TttServer.Router,
  session: [store: :cookie,
            key: "_ttt_session"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
