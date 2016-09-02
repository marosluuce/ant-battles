defmodule Engine do
  defstruct world: %World{}

  def start_link(args) do
    GenServer.start_link(
      EngineServer,
      %Engine{world: World.new(args)},
      name: EngineServer
    )
  end

  def join(team), do: execute(%Join{team: team})

  def spawn_ant(nest_id), do: execute(%SpawnAnt{nest_id: nest_id})

  def move_ant(ant_id, direction) do
    execute(%MoveAnt{ant_id: ant_id, velocity: Commands.move(direction)})
  end

  def look(ant_id), do: execute(%Look{ant_id: ant_id})

  def observe, do: execute(%Observe{})

  def add_food(location, quantity), do: execute(%AddFood{location: location, quantity: quantity})

  def info(id) do
    world = get_world()

    world
    |> World.find(id)
    |> format_info
  end

  defp format_info({:error, :not_found}), do: {:error, :invalid_id}
  defp format_info(entity), do: {:ok, Message.details(entity)}

  defp get_world, do: GenServer.call(EngineServer, :get_world)

  defp execute(command), do: GenServer.call(EngineServer, {:run, command})
end
