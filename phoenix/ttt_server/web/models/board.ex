defmodule TTTBoard do

  def new, do: HashDict.new

  def toString(nil), do: ""
  def toString(board) do
    board |> HashDict.to_list 
          |> Enum.sort(fn {k1, _}, {k2, _} -> k1<k2 end)
          |> Enum.map(fn {k,v} -> "#{k}=#{v}" end)
          |> Enum.join(", ")
  end

# +---+---+---+
# |A1 |B1 |C1 |
# +---+---+---+
# |A2 |B2 |C2 |
# +---+---+---+
# |A3 |B3 |C3 |
# +---+---+---+


  def toASCII(board) do
    asciiboard = (1..3 |> Enum.reduce delimiter, &(&2 <> row(board, &1) <> "\n" <> delimiter))
    winningplayer = winner(board)
    if winningplayer != nil do
      asciiboard <> "\nGame over! Player #{winningplayer} wins"
    else
      asciiboard
    end
  end

  defp row(board, r) do
    ~w(A B C) |>
      Enum.reduce "|", &(&2 <> " " <> HashDict.get(board, "#{&1}#{r}", " ") <> " |")
  end

  defp delimiter do 
    "+---+---+---+\n"
  end

  def setValue(board, coor, val) do
    cond do
      not valid_coordinate?(coor) -> {:invalid, board}
      not valid_value?(val)       -> {:invalid, board}
      not valid_turn?(board, val) -> {:notyourturn, board}
      is_occupied? board, coor    -> {:occupied, board}
      winner(board) != nil        -> {:gameover, board}
      true                        -> {:ok, HashDict.put(board, coor, val)}
    end
  end

  def getValue(board, coor), do: HashDict.get(board, coor, :invalid)

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

  def winner(board) do
    cond do
      winner?(board, "x") -> "x"
      winner?(board, "o") -> "o"
      true -> nil
    end
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
