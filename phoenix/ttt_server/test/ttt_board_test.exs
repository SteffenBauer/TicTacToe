defmodule TttServerTest do
  use ExUnit.Case

  test "set Value" do
    board = TTTBoard.new
    {:ok, board} = TTTBoard.setValue(board, "A3", "x")
    assert TTTBoard.getValue(board, "A3") == "x"
  end
  
  test "toString" do
    board = TTTBoard.new
    {:ok, board} = TTTBoard.setValue(board, "A2", "x")
    {:ok, board} = TTTBoard.setValue(board, "C3", "o")
    assert TTTBoard.toString(board) == "A2=x, C3=o"
  end

  test "Duplicate Set" do
    board = TTTBoard.new
    {:ok, board} = TTTBoard.setValue(board, "A2", "x")
    {response, _board} = TTTBoard.setValue(board, "A2", "o")
    assert response == :occupied
  end

end
