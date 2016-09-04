defmodule Nests do
  def registered?(nests, team) do
    nests
    |> Enum.map(&(&1.team))
    |> Enum.member?(team)
  end
end
