defmodule Message do
  def details(nest = %Nest{}, world) do
    num_ants = world
    |> World.ants
    |> Enum.filter(&(&1.nest_id == nest.id))
    |> Enum.count

    %{
      type: :nest,
      location: nest.pos,
      food: nest.food,
      team: nest.team,
      id: nest.id,
      ants: num_ants
    }
  end

  def details(ant = %Ant{}, _) do
    %{
      type: :ant,
      location: ant.pos,
      id: ant.id,
      nest: ant.nest_id,
      surroundings: %{},
      team: ant.team,
      got_food: ant.has_food
    }
  end
end
