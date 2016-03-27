defmodule Nest do
  defstruct name: "", id: 0, pos: {0, 0}, food: 5

  def consume_food(nest=%Nest{food: food}) when food <= 0 do
    {:error, "Nest #{nest.name} has insufficent food."}
  end

  def consume_food(nest) do
    {:ok, %{nest | food: nest.food - 1}}
  end

  def deliver_food(nest), do: Map.update!(nest, :food, &(&1 + 1))
end
