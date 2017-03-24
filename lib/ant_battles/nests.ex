defmodule AntBattles.Nests do
  def registered?(nests, team) do
    nests
    |> Enum.map(fn {_, nest} -> nest.team end)
    |> Enum.member?(team)
  end
end
