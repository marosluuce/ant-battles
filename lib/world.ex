defmodule World do
  defstruct nests: [], ants: [], food: %{}

  def new(args) do
    food_stacks = Keyword.get(args, :food_stacks, 0)
    food_stack_size = Keyword.get(args, :food_stack_size, 0)

    add_initial_food(%World{}, food_stacks, food_stack_size)
  end

  defp add_initial_food(world, 0, _), do: world
  defp add_initial_food(world, stacks, stack_size) do
    (1..stacks)
    |> Enum.map(fn _ -> random_location() end)
    |> Enum.reduce(world, fn (location, world) -> spawn_food(world, location, stack_size) end)
  end

  defp random_location do
    x = :rand.uniform(50) - 25
    y = :rand.uniform(50) - 25

    if {x, y} == {0, 0} do
      random_location()
    else
      {x, y}
    end
  end

  def register(world, team) do
    if registered?(world, team) do
      {:error, :name_taken}
    else
      {:ok, add_nest(world, new_nest(team))}
    end
  end

  defp add_nest(world = %World{nests: nests}, nest), do: %{world | nests: [nest | nests]}

  defp new_nest(team), do: %Nest{id: id(), team: team}

  def spawn_ant(world, nest_id) do
    {nest, world} = fetch_nest(world, nest_id)
    do_spawn_ant(nest, world)
  end

  defp do_spawn_ant({:error, _}, _), do: {:error, :unknown_nest}
  defp do_spawn_ant(nest, world) do
    spawn_ant(world, nest.id, Nest.spawn_ant(nest))
  end

  defp spawn_ant(_, _, {:error, msg}), do: {:error, msg}
  defp spawn_ant(world, _, nest) do
    new_ant = %Ant{id: id(), nest_id: nest.id, pos: nest.pos, team: nest.team}

    {:ok, %{world | nests: [nest | world.nests], ants: [new_ant | world.ants]}}
  end

  def spawn_food(world, position, quantity \\ 1) do
    %{world | food: Map.update(world.food, position, quantity, &(&1 + quantity))}
  end

  def pick_up_food(world, position), do: %{world | food: Map.update(world.food, position, 0, &(&1 - 1))}

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

  defp find_neighbors(positions, world)  do
    ants = world |> World.ants
    nests = world |> World.nests

    ants ++ nests
    |> Enum.filter(&(&1.pos in positions))
  end

  defp group_by_position(entities), do: Enum.group_by(entities, &(&1.pos))

  defp convert_position_keys_to_direction(neighbors, pos) do
    neighbors
    |> Enum.map(&(convert_position(pos, &1)))
    |> Enum.into(%{})
  end

  defp convert_position({x1, y1}, {{x2, y2}, entities}) do
    {:ok, direction} = Move.to_dir({x2 - x1, y2 - y1})
    {direction, entities}
  end

  def move_ant(world, ant_id, direction) do
    {ant, world} = fetch_ant(world, ant_id)
    do_move_ant(ant, world, direction)
  end

  defp amount_of_food_at(world, pos), do: Map.get(world.food, pos, 0)

  defp ant_reached_own_nest?(world, ant) do
    case World.find(world, ant.nest_id) do
      %Nest{pos: pos} -> pos == ant.pos
      _ -> false
    end
  end

  defp ant_delivered_food?(world, ant), do: ant_reached_own_nest?(world, ant) && ant.has_food

  defp ant_found_food?(_, %Ant{has_food: true}), do: false
  defp ant_found_food?(world, ant), do: amount_of_food_at(world, ant.pos) > 0

  defp ant_gets_food(world, ant) do
    %{world | ants: [Ant.pick_up_food(ant) | world.ants]} |> pick_up_food(ant.pos)
  end

  defp ant_delivers_food(world, ant) do
    {nest, world} = fetch_nest(world, ant.nest_id)

    %{world | ants: [Ant.drop_food(ant) | world.ants], nests: [Nest.deliver_food(nest) | world.nests]}
  end

  defp fetch_ant(world, ant_id) do
    ant = World.find(world, ant_id)
    world = %{world | ants: List.delete(world.ants, ant)}

    {ant, world}
  end

  defp fetch_nest(world, nest_id) do
    nest = World.find(world, nest_id)
    world = %{world | nests: List.delete(world.nests, nest)}

    {nest, world}
  end

  defp do_move_ant({:error, _}, _, _), do: {:error, :unknown_ant}
  defp do_move_ant(ant, world, direction) do
    moved_ant = Ant.move(ant, direction)

    cond do
      ant_found_food?(world, moved_ant) ->
        {:ok, ant_gets_food(world, moved_ant)}

      ant_delivered_food?(world, moved_ant) ->
        {:ok, ant_delivers_food(world, moved_ant)}

      true ->
        {:ok, %{world | ants: [moved_ant | world.ants]}}
    end
  end

  def newest_ant(world, nest_id) do
    world
    |> ants_by_nest(nest_id)
    |> Enum.max_by(&(&1.id))
  end

  def ant(world, id) do
    world
    |> World.ants
    |> Enum.find(&(&1.id == id))
  end

  def ants(%World{ants: ants}), do: ants

  def ants_by_nest(world, nest_id) do
    world
    |> World.ants
    |> Enum.filter(&(&1.nest_id == nest_id))
  end

  def nest(world, team) do
    world
    |> World.nests
    |> Enum.find({:error, :not_found}, &(&1.team == team))
  end

  def nests(%World{nests: nests}), do: nests

  def food(%World{food: food}), do: food

  def find(world, id) do
    ants = world |> World.ants
    nests = world |> World.nests

    nests ++ ants |> Enum.find({:error, :not_found}, &(&1.id == id))
  end

  defp registered?(world, team) do
    case nest(world, team) do
      %Nest{} -> true
      _ -> false
    end
  end

  defp id, do: System.system_time()
end
