defmodule TttServer.TTTController do
  use Phoenix.Controller

  plug :action

  def index(conn, _params) do
    redirect conn, to: "/tictactoe?CMD=HELP"
  end

  def tictactoe(conn, param) do
    case Map.get param, "CMD" do
      "HELP"    -> show_help conn, param
      "RESET"   -> reset_session conn, param
      "DESTROY" -> destroy_session conn, param
      "SHOW"    -> show_field conn, param
      "SET"     -> do_set conn, param
      nil       -> show_help conn, param
      _other    -> render_msg conn, param, "ERROR: Unknown command"
    end
  end

  defp destroy_session(conn, param) do
    conn = delete_session(conn, :game)
    render_msg conn, param, "DESTROYED"
  end

  defp reset_session(conn, param) do
    conn = put_session(conn, :game, TTTBoard.new)
    render_msg conn, param, "OK"
  end

  defp do_set(conn, param) do
    board = get_session(conn, :game)
    if board == nil, do: board = TTTBoard.new
    coordinate = Map.get(param, "coordinate")
    value = Map.get(param, "value")
    cond do
      coordinate == nil -> render_msg conn, param, "ERROR: Parameter coordinate missing"
      value == nil      -> render_msg conn, param, "ERROR: Parameter value missing"
      true              -> handle_newboard(conn, param, TTTBoard.setValue(board, coordinate, value))
    end
  end

  defp handle_newboard(conn, param, response) do
    case response do
      {:invalid, _board}  -> render_msg conn, param, "ERROR: Invalid parameters"
      {:occupied, _board} -> render_msg conn, param, "ERROR: Field is already occupied"
      {:ok, board}        -> put_session(conn, :game, board) |> show_field(param)
    end
  end

  defp show_field(conn, param) do
    render_msg conn, param, "FIELD: #{get_session(conn, :game)|> TTTBoard.toString }"
  end

  defp show_help(conn, param) do
    render_msg conn, param, TttServer.HelpView.helptext
  end

  defp render_msg(conn, param, msg) do
    case Map.get param, "FORMAT" do
      "HTML" -> conn |> put_layout(:ttt) |> render("tictactoe.html", message: msg)
      _other -> text conn, msg
    end
  end

end
