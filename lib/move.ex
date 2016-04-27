defmodule Move do
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
    if valid?(point) do
      {:ok, find_dir_for(point)}
    else
      {:error, :invalid_direction}
    end
  end

  defp valid?(point) do
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
