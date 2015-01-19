defmodule TttBoardTest do
  use ExUnit.Case

  @doc ~S"""
  Takes a list of game moves, sets each move consecutively starting with a new board,
  testing each turn for the correct outcome.
  
  The list of game moves consists of 4-element tuples
  { field, value, response, winner } for each turn, with the fields:
    * field - Which field to set in this turn ("A1" .. "C3")
    * value - Which symbol to set in this turn ("x" or "o")
    * response - Expected server response (:ok, :notyourturn, :occupied, :gameover)
    * winner - Expected winner after this move ("x", "o" or nil)
  
  Returns the board after all given moves are played.
  """
  def play_ttt_test_game(moves) do
    moves 
    |> Enum.reduce(TTTBoard.new, 
         fn { field, val, res, win }, board -> 
           {response, newboard} = TTTBoard.setValue(board, field, val)
           winner = TTTBoard.winner(newboard)
           assert {field, val, response, winner} == {field, val, res, win}
           newboard
         end)
  end

  test "set Value" do
    board = TTTBoard.new
    {:ok, board} = TTTBoard.setValue(board, "A3", "x")
    assert TTTBoard.getValue(board, "A3") == "x"
  end
  
  test "toString" do
    moves = [ {"A2", "x", :ok, nil}, 
              {"C3", "o", :ok, nil} ]
    board = play_ttt_test_game(moves)
    assert TTTBoard.toString(board) == "A2=x, C3=o"
  end

  test "Duplicate Set" do
    moves = [ {"A2", "x", :ok, nil}, 
              {"A2", "o", :occupied, nil} ]
    play_ttt_test_game(moves)
  end

  test "Invalid coordinate" do
    moves = [ {"A2", "x", :ok, nil}, 
              {"D1", "o", :invalid, nil},
              {"B6", "x", :invalid, nil} ]
    play_ttt_test_game(moves)
  end

  test "Invalid symbol" do
    moves = [ {"A2", "y", :invalid, nil}, 
              {"A3", "1", :invalid, nil},
              {"B1", nil, :invalid, nil} ]
    play_ttt_test_game(moves)
  end

  test "Player X goes first" do
    moves = [ {"A2", "o", :notyourturn, nil}, 
              {"A2", "x", :ok, nil},
              {"B1", "o", :ok, nil} ]
    play_ttt_test_game(moves)
  end

  test "Player may not take two consecutive turns" do
    moves = [ {"A2", "x", :ok, nil}, 
              {"A1", "x", :notyourturn, nil}, 
              {"A1", "o", :ok, nil}, 
              {"A3", "o", :notyourturn, nil} ]
    play_ttt_test_game(moves)
  end

  test "Player X wins row" do
    moves = [ {"A1", "x", :ok, nil}, 
              {"A2", "o", :ok, nil}, 
              {"B1", "x", :ok, nil}, 
              {"B2", "o", :ok, nil}, 
              {"C1", "x", :ok, "x"} ]
    play_ttt_test_game(moves)
  end

  test "Player O wins column" do
    moves = [ {"A1", "x", :ok, nil}, 
              {"B1", "o", :ok, nil}, 
              {"A2", "x", :ok, nil}, 
              {"B2", "o", :ok, nil}, 
              {"C3", "x", :ok, nil},
              {"B3", "o", :ok, "o"} ]
    play_ttt_test_game(moves)
  end

  test "Player X wins diagonal" do
    moves = [ {"A1", "x", :ok, nil}, 
              {"A2", "o", :ok, nil}, 
              {"B2", "x", :ok, nil}, 
              {"C1", "o", :ok, nil}, 
              {"C3", "x", :ok, "x"} ] 
    play_ttt_test_game(moves)
  end

  test "Player X wins counter-diagonal" do
    moves = [ {"A3", "x", :ok, nil}, 
              {"A2", "o", :ok, nil}, 
              {"B2", "x", :ok, nil}, 
              {"B1", "o", :ok, nil}, 
              {"C1", "x", :ok, "x"} ] 
    play_ttt_test_game(moves)
  end

  test "No more turns allowed after game win" do
    moves = [ {"A3", "x", :ok, nil}, 
              {"A2", "o", :ok, nil}, 
              {"B2", "x", :ok, nil}, 
              {"B1", "o", :ok, nil},
              {"C1", "x", :ok, "x"},
              {"B3", "o", :gameover, "x"} ]
    play_ttt_test_game(moves)
  end

  test "Tied game" do
    moves = [ {"B2", "x", :ok, nil}, 
              {"A1", "o", :ok, nil}, 
              {"B1", "x", :ok, nil}, 
              {"B3", "o", :ok, nil},
              {"A3", "x", :ok, nil},
              {"C1", "o", :ok, nil}, 
              {"C2", "x", :ok, nil}, 
              {"A2", "o", :ok, nil}, 
              {"C3", "x", :ok, :tie}, 
              {"C3", "o", :gameover, :tie} ]
    play_ttt_test_game(moves)
  end


end
