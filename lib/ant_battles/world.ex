defmodule AntBattles.World do
  alias AntBattles.Stores
  alias AntBattles.Move
  alias AntBattles.Nest

  def new_nest(team), do: Nest.create(AntBattles.Id.random(), team)

  def surroundings(world, id) do
    world
    |> find(id)
    |> find_surroundings(world)
  end

  defp find_surroundings(%{pos: pos}, world) do
    result = pos
    |> neighbors
    |> find_neighbors(world)
    |> group_by_position
    |> convert_position_keys_to_direction(pos)

    empty = %{n: [], s: [], e: [], w: [], ne: [], nw: [], se: [], sw: []}

    {:ok, Map.merge(empty, result)}
  end
  defp find_surroundings(_, _), do: {:error, :id_not_found}

  defp neighbors({x, y}) do
    [{x-1, y-1}, {x, y-1}, {x+1, y-1},
     {x-1, y},             {x+1, y},
     {x-1, y+1}, {x, y+1}, {x+1, y+1}]
  end

  defp find_neighbors(positions, name)  do
    Stores.Ants.all(name) ++ Stores.Nests.all(name) ++ Stores.Food.all(name)
    |> Enum.filter(fn obj -> obj.pos in positions end)
  end

  defp group_by_position(entities) do
    entities |> Enum.group_by(&(&1.pos))
  end

  defp convert_position_keys_to_direction(neighbors, pos) do
    neighbors
    |> Enum.map(&(convert_position(pos, &1)))
    |> Enum.into(%{})
  end

  defp convert_position({x1, y1}, {{x2, y2}, entities}) do
    {:ok, direction} = Move.to_dir({x2 - x1, y2 - y1})
    {direction, entities}
  end

  def newest_ant(name, nest_id) do
    name
    |> Stores.Ants.ants_by_nest_id(nest_id)
    |> Enum.max_by(fn ant -> ant.id end)
  end

  def find(name, id) do
    case Map.merge(Stores.Nests.get_map(name), Stores.Ants.get_map(name)) |> Map.fetch(id) do
      :error -> {:error, :not_found}
      {:ok, thing} -> thing
    end
  end
end
