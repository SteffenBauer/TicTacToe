use Mix.Config

# ## SSL Support
#
# To get SSL working, you will need to set:
#
#     https: [port: 443,
#             keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#             certfile: System.get_env("SOME_APP_SSL_CERT_PATH")]
#
# Where those two env variables point to a file on
# disk for the key and cert.

config :ttt_server, TttServer.Endpoint,
#  url: [host: "example.com"],
  http: [port: System.get_env("PORT") || 4001],
  secret_key_base: "tWLYs9dOhV3E9aH1HwVd6BPuD/OHlVNka01c9zO3fWj7jPxV4AmVmgZxvN0/e3t4"

# Do not pring debug or info messages in production
config :logger, level: :warn

# ## Using releases
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start the server for all endpoints:
#
#     config :phoenix, :serve_endpoints, true
#
# Alternatively, you can configure exactly which server to
# start per endpoint:
#
#     config :ttt_server, TttServer.Endpoint, server: true
#
