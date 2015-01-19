defmodule TTTBoard do

  @moduledoc ~S"""
  TicTacToe board and gameplay functions.
  
  This module provides the low-level functions operating on the TicTacToe
  board data structure.
    
  ## Coordinates
    
  Game coordinates are formatted as two-character strings, using these
  positions on the game board:

      +---+---+---+
      |A1 |B1 |C1 |
      +---+---+---+
      |A2 |B2 |C2 |
      +---+---+---+
      |A3 |B3 |C3 |
      +---+---+---+
    
  ## Player symbols
    
  Players are traditionally `X` and `O`. Player symbols provided to functions
  are using one-character strings, either "x" or "o".
    
  ## Game play
    
  Player 'X' always starts the game.
  """

  @doc ~S"""
  Returns a new clean TicTacToe board.
  """
  def new, do: HashDict.new

  @doc ~S"""
  Returns the board formatted as a string.
  """
  def toString(nil), do: ""
  def toString(board) do
    board |> HashDict.to_list 
          |> Enum.sort(fn {k1, _}, {k2, _} -> k1<k2 end)
          |> Enum.map(fn {k,v} -> "#{k}=#{v}" end)
          |> Enum.join(", ")
  end

  @header    "    A   B   C  \n"
  @delimiter "  +---+---+---+\n"

  @doc ~S"""
  Returns the board nicely formatted in ASCII characters.
  """
  def toASCII(board) do
    asciiboard = (1..3 |> Enum.reduce @delimiter, &(&2 <> "#{&1} " <> row(board, &1) <> "\n" <> @delimiter))
    winningplayer = winner(board)
    @header <> asciiboard <> cond do
      winningplayer == :tie      -> "\nGame is a draw."
      winningplayer in ["x","o"] -> "\nGame over! Player #{winningplayer} wins"
      true                       -> ""
    end
  end

  defp row(board, r) do
    ~w(A B C) |>
      Enum.reduce "|", &(&2 <> " " <> HashDict.get(board, "#{&1}#{r}", " ") <> " |")
  end

  @doc ~S"""
  Make a game move.
  
    * `coor` - Coordinate where to set the move ("A1" .. "C3")
    * `val` - Symbol to set ("x" or "o")
    
  Returns a 2-element tuple `{response, newboard}`. `response` can be one of:
    * `:ok` - Move was valid
    * `:invalid` - A completely wrong move was made, either out-of-bounds
      coordinates or a wrong symbol
    * `:notyourturn` - Tried a move when it is not the players turn
    * `:occupied` - Tried to set an already occupied grid space
    * `:gameover` - Tried to make a move on an already finished game.
    
  `newboard` is the new board when the move was valid, or the unmodified board
  in case of any erroneous move.
  """
  def setValue(board, coor, val) do
    cond do
      winner(board) != nil        -> {:gameover, board}
      not valid_coordinate?(coor) -> {:invalid, board}
      not valid_value?(val)       -> {:invalid, board}
      not valid_turn?(board, val) -> {:notyourturn, board}
      is_occupied? board, coor    -> {:occupied, board}
      true                        -> {:ok, HashDict.put(board, coor, val)}
    end
  end

  @doc ~S"""
  Returns the current symbol at `coor`, or `:invalid` if the grid cell is
  unoccupied or the requested coordinate is not valid.
  """
  def getValue(board, coor), do: HashDict.get(board, coor, :invalid)

  @doc ~S"""
  Determine whether the board is a winning game, a draw, or still in
  progress.
  
  Returns one of:
    * `"x"` - Game was won, winner is 'X'.
    * `"o"` - Game was won, winner is 'O'.
    * `:tie` - Game is a draw.
    * `nil` - Game is not decided.
  """
  def winner(board) do
    cond do
      winner?(board, "x") -> "x"
      winner?(board, "o") -> "o"
      (board |> HashDict.size) == 9 -> :tie
      true -> nil
    end
  end

  defp is_occupied?(board, coor), do: HashDict.has_key?(board, coor)

  defp valid_coordinate?(coor) do
    String.length(coor) == 2 and 
    String.first(coor) in ["A", "B", "C"] and
    String.last(coor) in ["1", "2", "3"]
  end

  defp valid_value?(value), do: value in ["x", "o"]

  defp valid_turn?(board, "x"), do: boardcount(board) == 0
  defp valid_turn?(board, "o"), do: boardcount(board) == 1
  defp boardcount(board) do
    v = HashDict.values(board)
    Enum.count(v,&(&1=="x")) - Enum.count(v,&(&1=="o"))
  end

  defp winner?(board, player) do
      (~w(1 2 3) |> Enum.map(&(winline?(board, &1, player, :row))) |> Enum.any?) or
      (~w(A B C) |> Enum.map(&(winline?(board, &1, player, :col))) |> Enum.any?) or
      diagonal?(board, player, ~w(A1 B2 C3)) or
      diagonal?(board, player, ~w(A3 B2 C1))
  end

  defp diagonal?(board, val, diag) do
    (board 
      |> HashDict.to_list
      |> Enum.filter(fn {k,v} -> k in diag and v == val end)
      |> Enum.count) == 3
  end

  defp winline?(board, coor, val, dir) do
    index = case dir do
      :row -> &String.last/1
      :col -> &String.first/1
    end
    (board 
      |> HashDict.to_list
      |> Enum.filter(fn {k,v} -> index.(k) == index.(coor) and v == val end)
      |> Enum.count) == 3
  end

end
