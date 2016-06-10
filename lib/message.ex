defmodule Message do
  def details(nest = %Nest{}) do
    %{
      type: :nest,
      location: nest.pos |> Tuple.to_list,
      food: nest.food,
      team: nest.team,
      id: nest.id,
      ants: nest.ants
    }
  end

  def details(ant = %Ant{}) do
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
    |> Enum.map(&detailed/1)
    |> Enum.into(%{})

    ant
    |> details
    |> Map.put(:surroundings, detailed)
  end

  defp detailed({dir, entities}) do
    {dir, Enum.map(entities, &details/1)}
  end
end
