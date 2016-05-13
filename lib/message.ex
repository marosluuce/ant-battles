defmodule Message do
  def details(nest = %Nest{}, world) do
    num_ants = world
    |> World.ants
    |> Enum.filter(&(&1.nest_id == nest.id))
    |> Enum.count

    %{
      type: :nest,
      location: nest.pos |> Tuple.to_list,
      food: nest.food,
      team: nest.team,
      id: nest.id,
      ants: num_ants
    }
  end

  def details(ant = %Ant{}, _) do
    %{
      type: :ant,
      location: ant.pos |> Tuple.to_list,
      id: ant.id,
      nest: ant.nest_id,
      team: ant.team,
      got_food: ant.has_food
    }
  end

  def with_surroundings(ant = %Ant{}, world) do
    {:ok, surroundings} = world
    |> World.surroundings(ant.id)

    detailed = surroundings
    |> Enum.map(&(detailed(&1, world)))
    |> Enum.into(%{})

    ant
    |> details(world)
    |> Map.put(:surroundings, detailed)
  end

  defp detailed({dir, entities}, world) do
    {dir, Enum.map(entities, &(details(&1, world)))}
  end
end
