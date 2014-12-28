defmodule TttServer.Router do
  use Phoenix.Router

  pipeline :browser do
    plug :accepts, ~w(html)
    plug :fetch_session
  end

  scope "/", TttServer do
    pipe_through :browser

    get "/", TTTController, :index
    get "/tictactoe", TTTController, :tictactoe

  end

end
