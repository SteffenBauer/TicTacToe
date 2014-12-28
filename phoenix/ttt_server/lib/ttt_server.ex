defmodule TttServer do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
#      worker(TttServer.TTTModel, [[name: TTT.Session]])
    ]

    opts = [strategy: :one_for_one, name: TttServer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def config_change(changed, _new, removed) do
    TttServer.Endpoint.config_change(changed, removed)
    :ok
  end

end
