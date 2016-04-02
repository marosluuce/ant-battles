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
      team: ant.team,
      got_food: ant.has_food
    }
  end

  def with_surroundings(ant = %Ant{}, world) do
    surroundings = %{
      n: [],
      s: [],
      e: [],
      w: [],
      ne: [],
      nw: [],
      se: [],
      sw: []
    }

    ant
    |> details(world)
    |> Map.put(:surroundings, surroundings)
  end
end
