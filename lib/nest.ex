defmodule Nest do
  defstruct team: "", id: 0, pos: {0, 0}, food: 5

  def consume_food(nest = %Nest{food: food}) when food > 0, do: {:ok, %{nest | food: food - 1}}
  def consume_food(_), do: {:error, :insufficient_food}

  def deliver_food(nest), do: %{nest | food: nest.food + 1}
end
