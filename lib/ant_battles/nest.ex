defmodule AntBattles.Nest do

  defstruct team: "", id: 0, pos: {0, 0}, food: 5, ants: 0

  def create(id, team) do
    %__MODULE__{team: team, id: id}
  end

  def spawn_ant(nest) do
    with updated = %__MODULE__{} <- consume_food(nest) do
      update_in(updated.ants, &(&1 + 1))
    else
      _ -> nest
    end
  end

  def deliver_food(nest), do: update_in(nest.food, &(&1 + 1))

  defp consume_food(nest = %__MODULE__{food: food}) when food > 0 do
    update_in(nest.food, &(&1 - 1))
  end
  defp consume_food(_), do: {:error, :insufficient_food}
end
