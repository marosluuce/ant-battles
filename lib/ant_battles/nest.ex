defmodule AntBattles.Nest do
  alias AntBattles.Nest

  defstruct team: "", id: 0, pos: {0, 0}, food: 5, ants: 0

  def spawn_ant(nest) do
    nest
    |> consume_food
    |> update_ant_count
  end

  defp update_ant_count(nest = %Nest{}), do: update_in(nest.ants, &(&1 + 1))
  defp update_ant_count(error), do: error

  def deliver_food(nest), do: update_in(nest.food, &(&1 + 1))

  defp consume_food(nest=%Nest{food: food}) when food > 0 do
    update_in(nest.food, &(&1 - 1))
  end
  defp consume_food(_), do: {:error, :insufficient_food}
end
