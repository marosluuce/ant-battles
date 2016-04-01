defmodule Commands do
  def move("n"), do: {0, 1}
  def move("s"), do: {0, -1}
  def move("e"), do: {1, 0}
  def move("w"), do: {-1, 0}
  def move("nw"), do: {-1, 1}
  def move("ne"), do: {1, 1}
  def move("sw"), do: {-1, -1}
  def move("se"), do: {1, -1}
  def move(_), do: {0, 0}
end
