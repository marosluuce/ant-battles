defmodule World do
  defstruct nests: [], ants: [], food: []

  def register(world, name) do
    if registered?(world, name) do
      {:error, :name_taken}
    else
      {:ok, Map.update!(world, :nests, &([%Nest{name: name} | &1]))}
    end
  end

  def spawn(world, id) do
    {found, nests} = world.nests |> Enum.partition(&(&1.id == id))

    case found do
      [nest] ->
        spawn_ant(world, id, Nest.consume_food(nest), nests)
      _ ->
        {:error, :unknown_nest}
    end
  end

  def spawn_food(world, position, quantity \\ 1) do
    %{world | food: List.duplicate(position, quantity) ++ world.food}
  end

  def pick_up_food(world, position) do
    %{world | food: List.delete(world.food, position)}
  end

  def move_ant(world, ant_id, direction) do
    {found, ants} = world.ants |> Enum.partition(&(&1.id == ant_id))

    case found do
      [ant] ->
        {:ok, %{world | ants: [Ant.move(ant, direction) | ants]}}
      _ ->
        {:error, :unknown_ant}
    end
  end

  def ants(%World{ants: ants}), do: ants

  def nests(%World{nests: nests}), do: nests

  def food(%World{food: food}), do: food

  defp spawn_ant(world, _, {:ok, nest}, nests) do
    new_world =
      %{world |
        nests: [nest | nests],
        ants: [%Ant{id: id(), pos: nest.pos} | world.ants]}

    {:ok, new_world}
  end

  defp spawn_ant(_, _, {:error, _}, _) do
    {:error, :insufficient_food}
  end

  defp registered?(world, name) do
    world.nests
    |> Enum.map(&(&1.name))
    |> Enum.member?(name)
  end

  defp id, do: System.unique_integer([:positive])
end
