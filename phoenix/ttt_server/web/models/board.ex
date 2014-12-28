defmodule TTTBoard do

  def new, do: HashDict.new

  def toString(nil), do: ""
  def toString(board) do
    board |> HashDict.to_list 
          |> Enum.sort(fn {k1, _}, {k2, _} -> k1<k2 end)
          |> _toString("")
  end

  defp _toString(board, s) do
    case board do
      []         -> s
      [{k,v}|[]] -> s <> "#{k}=#{v}"
      [{k,v}|t ] -> _toString t, s <> "#{k}=#{v}, "
    end
  end

  def setValue(board, coor, val) do
    cond do
      not valid_coordinate?(coor) -> {:invalid, board}
      not valid_value?(val)       -> {:invalid, board}
      is_occupied? board, coor    -> {:occupied, board}
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

end
