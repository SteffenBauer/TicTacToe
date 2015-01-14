defmodule TttServer.Endpoint do
  use Phoenix.Endpoint, otp_app: :ttt_server

  plug Plug.Static,
    at: "/", from: :ttt_server

  plug Plug.Logger

  # Code reloading will only work if the :code_reloader key of
  # the :phoenix application is set to true in your config file.
  plug Phoenix.CodeReloader

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Poison

  plug Plug.MethodOverride
  plug Plug.Head

  plug Plug.Session,
    store: :cookie,
    key: "_ttt_server_key",
    signing_salt: "eYZPGKtp",
    encryption_salt: "jy44sRP3"

  plug :router, TttServer.Router
end
