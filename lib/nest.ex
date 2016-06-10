defmodule Nest do
  defstruct team: "", id: 0, pos: {0, 0}, food: 500, ants: 0

  def spawn_ant(nest) do
    nest
    |> consume_food
    |> update_ant_count
  end

  defp update_ant_count(nest = %Nest{}), do: %{nest | ants: nest.ants + 1}
  defp update_ant_count(error), do: error

  def deliver_food(nest), do: %{nest | food: nest.food + 1}

  defp consume_food(nest = %Nest{food: food}) when food > 0, do: %{nest | food: food - 1}
  defp consume_food(_), do: {:error, :insufficient_food}
end
