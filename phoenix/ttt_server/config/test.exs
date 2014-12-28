use Mix.Config

config :ttt_server, TttServer.Endpoint,
  http: [port: System.get_env("PORT") || 4001]
