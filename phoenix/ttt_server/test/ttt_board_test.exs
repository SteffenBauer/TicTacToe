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

  test "Player X goes first" do
    board = TTTBoard.new
    {response, _board} = TTTBoard.setValue(board, "A2", "x")
    assert response == :ok
    board = TTTBoard.new
    {response, _board} = TTTBoard.setValue(board, "A2", "o")
    assert response == :notyourturn
  end

  test "Player may not take two consecutive turns" do
    board= TTTBoard.new
    {response, board} = TTTBoard.setValue(board, "A2", "x")
    assert response == :ok
    {response, board} = TTTBoard.setValue(board, "A1", "x")
    assert response == :notyourturn
    {response, board} = TTTBoard.setValue(board, "A1", "o")
    assert response == :ok
    {response, board} = TTTBoard.setValue(board, "A3", "o")
    assert response == :notyourturn
  end

  test "Player X wins row" do
    board= TTTBoard.new
    {response, board} = TTTBoard.setValue(board, "A1", "x")
    assert response == :ok
    assert TTTBoard.winner(board) == nil
    {response, board} = TTTBoard.setValue(board, "A2", "o")
    assert response == :ok
    assert TTTBoard.winner(board) == nil
    {response, board} = TTTBoard.setValue(board, "B1", "x")
    assert response == :ok
    assert TTTBoard.winner(board) == nil
    {response, board} = TTTBoard.setValue(board, "B2", "o")
    assert response == :ok
    assert TTTBoard.winner(board) == nil
    {response, board} = TTTBoard.setValue(board, "C1", "x")
    assert response == :ok
    assert TTTBoard.winner(board) == "x"
  end

  test "Player O wins column" do
    board= TTTBoard.new
    {response, board} = TTTBoard.setValue(board, "A1", "x")
    assert response == :ok
    assert TTTBoard.winner(board) == nil
    {response, board} = TTTBoard.setValue(board, "B1", "o")
    assert response == :ok
    assert TTTBoard.winner(board) == nil
    {response, board} = TTTBoard.setValue(board, "A2", "x")
    assert response == :ok
    assert TTTBoard.winner(board) == nil
    {response, board} = TTTBoard.setValue(board, "B2", "o")
    assert response == :ok
    assert TTTBoard.winner(board) == nil
    {response, board} = TTTBoard.setValue(board, "C3", "x")
    assert response == :ok
    assert TTTBoard.winner(board) == nil
    {response, board} = TTTBoard.setValue(board, "B3", "o")
    assert response == :ok
    assert TTTBoard.winner(board) == "o"
  end

  test "Player X wins diagonal" do
    board= TTTBoard.new
    {response, board} = TTTBoard.setValue(board, "A1", "x")
    assert response == :ok
    assert TTTBoard.winner(board) == nil
    {response, board} = TTTBoard.setValue(board, "A2", "o")
    assert response == :ok
    assert TTTBoard.winner(board) == nil
    {response, board} = TTTBoard.setValue(board, "B2", "x")
    assert response == :ok
    assert TTTBoard.winner(board) == nil
    {response, board} = TTTBoard.setValue(board, "C1", "o")
    assert response == :ok
    assert TTTBoard.winner(board) == nil
    {response, board} = TTTBoard.setValue(board, "C3", "x")
    assert response == :ok
    assert TTTBoard.winner(board) == "x"
  end

  test "Player X wins counter-diagonal" do
    board= TTTBoard.new
    {response, board} = TTTBoard.setValue(board, "A3", "x")
    assert response == :ok
    assert TTTBoard.winner(board) == nil
    {response, board} = TTTBoard.setValue(board, "A2", "o")
    assert response == :ok
    assert TTTBoard.winner(board) == nil
    {response, board} = TTTBoard.setValue(board, "B2", "x")
    assert response == :ok
    assert TTTBoard.winner(board) == nil
    {response, board} = TTTBoard.setValue(board, "B1", "o")
    assert response == :ok
    assert TTTBoard.winner(board) == nil
    {response, board} = TTTBoard.setValue(board, "C1", "x")
    assert response == :ok
    assert TTTBoard.winner(board) == "x"
  end

  test "No more turns allowed after game win" do
    board= TTTBoard.new
    {response, board} = TTTBoard.setValue(board, "A3", "x")
    assert response == :ok
    assert TTTBoard.winner(board) == nil
    {response, board} = TTTBoard.setValue(board, "A2", "o")
    assert response == :ok
    assert TTTBoard.winner(board) == nil
    {response, board} = TTTBoard.setValue(board, "B2", "x")
    assert response == :ok
    assert TTTBoard.winner(board) == nil
    {response, board} = TTTBoard.setValue(board, "B1", "o")
    assert response == :ok
    assert TTTBoard.winner(board) == nil
    {response, board} = TTTBoard.setValue(board, "C1", "x")
    assert response == :ok
    assert TTTBoard.winner(board) == "x"
    {response, board} = TTTBoard.setValue(board, "B3", "o")
    assert response == :gameover
  end

end
