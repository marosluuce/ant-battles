defmodule Ant do
  defstruct id: 0, pos: {0, 0}, has_food: false

  def move(ant, {dx, dy}) do
    Map.update!(ant, :pos, fn {x, y} -> {x + dx, y + dy} end)
  end

  def pick_up_food(ant), do: %{ant | has_food: true}

  def drop_food(ant), do: %{ant | has_food: false}
end
