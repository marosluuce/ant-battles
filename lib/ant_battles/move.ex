defmodule AntBattles.Move do
  @directions %{
    n:  {0, 1},
    s:  {0, -1},
    e:  {1, 0},
    w:  {-1, 0},
    ne: {1, 1},
    nw: {-1, 1},
    se: {1, -1},
    sw: {-1, -1},
  }

  def from_dir(dir), do: Map.get(@directions, dir, {0, 0})

  def to_dir(point) do
    if valid_point?(point) do
      {:ok, find_dir_for(point)}
    else
      {:error, :invalid_direction}
    end
  end

  def convert_dir(string_dir) do
    if Enum.member?(string_directions(), string_dir) do
      String.to_atom(string_dir)
    else
      {:error, :unknown_direction}
    end
  end

  def string_directions do
    @directions
    |> Map.keys
    |> Enum.map(&to_string/1)
  end

  defp valid_point?(point) do
    @directions
    |> Map.values
    |> Enum.member?(point)
  end

  defp find_dir_for(point) do
    @directions
    |> Enum.find(fn {_, v} -> v == point end)
    |> elem(0)
  end
end
