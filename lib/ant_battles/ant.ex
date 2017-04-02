defmodule AntBattles.Ant do
  defstruct id: "", nest_id: 0, pos: {0, 0}, has_food: false, team: ""

  def create(id, nest) do
    %__MODULE__{id: id, nest_id: nest.id, pos: nest.pos, team: nest.team}
  end

  def move(ant, {dx, dy}) do
    update_in(ant.pos, fn {x, y} -> {x + dx, y + dy} end)
  end

  def pick_up_food(ant), do: %{ant | has_food: true}

  def drop_food(ant), do: %{ant | has_food: false}
end
