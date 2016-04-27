defmodule World do
  defstruct nests: [], ants: [], food: []

  def register(world, team) do
    if registered?(world, team) do
      {:error, :name_taken}
    else
      {:ok, Map.update!(world, :nests, &([%Nest{team: team} | &1]))}
    end
  end

  def spawn_ant(world, id) do
    world
    |> nests
    |> Enum.partition(&(&1.id == id))
    |> do_spawn_ant(world)
  end

  defp do_spawn_ant({[nest], nests}, world) do
    spawn_ant(world, nest.id, Nest.consume_food(nest), nests)
  end

  defp do_spawn_ant(_, _), do: {:error, :unknown_nest}

  def spawn_food(world, position, quantity \\ 1) do
    %{world | food: List.duplicate(position, quantity) ++ world.food}
  end

  def pick_up_food(world, position) do
    %{world | food: List.delete(world.food, position)}
  end

  def move_ant(world, ant_id, direction) do
    world
    |> ants
    |> Enum.partition(&(&1.id == ant_id))
    |> do_move_ant(world, direction)
  end

  defp do_move_ant({[ant], ants}, world, direction) do
    {:ok, %{world | ants: [Ant.move(ant, direction) | ants]}}
  end

  defp do_move_ant(_, _, _), do: {:error, :unknown_ant}

  def newest_ant(world, nest_id) do
    world
    |> ants_by_nest(nest_id)
    |> Enum.max_by(&(&1.id))
  end

  def ant(world, id), do: world |> World.ants |> Enum.find(&(&1.id == id))

  def ants(%World{ants: ants}), do: ants

  def ants_by_nest(world, nest_id) do
    world
    |> World.ants
    |> Enum.filter(&(&1.nest_id == nest_id))
  end

  def nest(world, team), do: world |> World.nests |> Enum.find(&(&1.team == team))

  def nests(%World{nests: nests}), do: nests

  def food(%World{food: food}), do: food

  def find(world, id) do
    ants = world |> World.ants
    nests = world |> World.nests

    nests ++ ants |> Enum.find(&(&1.id == id))
  end

  defp spawn_ant(world, _, {:ok, nest}, nests) do
    new_ant = %Ant{id: id(), nest_id: nest.id, pos: nest.pos, team: nest.team}

    {:ok, %{world | nests: [nest | nests], ants: [new_ant | world.ants]}}
  end

  defp spawn_ant(_, _, {:error, _}, _) do
    {:error, :insufficient_food}
  end

  defp registered?(world, team) do
    world.nests
    |> Enum.map(&(&1.team))
    |> Enum.member?(team)
  end

  defp id, do: System.unique_integer([:positive])
end
