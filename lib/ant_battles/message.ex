defmodule AntBattles.Message do
  alias AntBattles.Ant
  alias AntBattles.Food
  alias AntBattles.Nest
  alias AntBattles.World

  def details(nest = %Nest{}) do
    %{
      type: :nest,
      location: Tuple.to_list(nest.pos),
      food: nest.food,
      team: nest.team,
      id: nest.id,
      ants: nest.ants
    }
  end

  def details(ant = %Ant{}) do
    %{
      type: :ant,
      location: Tuple.to_list(ant.pos),
      id: ant.id,
      nest: ant.nest_id,
      team: ant.team,
      got_food: ant.has_food
    }
  end

  def details(food = %Food{}) do
    %{
      type: :food,
      location: Tuple.to_list(food.pos),
      quantity: food.quantity
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
