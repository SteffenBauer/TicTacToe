# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :ttt_server, TttServer.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "tWLYs9dOhV3E9aH1HwVd6BPuD/OHlVNka01c9zO3fWj7jPxV4AmVmgZxvN0/e3t4",
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
