defmodule Engine do
  defstruct delay: 1000, instructions: [], world: %World{}

  def start_link(delay) do
    result = GenServer.start_link(EngineServer, delay, name: EngineServer)
    start_tick()
    result
  end

  def join(team), do: execute(%Join{team: team})

  def spawn_ant(nest_id), do: execute(%SpawnAnt{nest_id: nest_id})

  def move_ant(ant_id, direction) do
    execute(%MoveAnt{ant_id: ant_id, velocity: Commands.move(direction)})
  end

  def look(ant_id), do: execute(%Look{ant_id: ant_id})

  def observe, do: execute(%Observe{pid: self()})

  def info(id) do
    world = get_world()

    world
    |> World.find(id)
    |> format_info(world)
  end

  defp format_info({:error, :not_found}, _), do: {:error, :invalid_id}
  defp format_info(entity, world), do: {:ok, Message.details(entity, world)}

  defp get_world, do: GenServer.call(EngineServer, :get_world)

  defp execute(command) do
    command
    |> enqueue
    |> respond
  end

  defp enqueue(command), do: GenServer.call(EngineServer, {:enqueue, command})

  defp respond({:ok, _}) do
    receive do
      {:ok, message} -> {:ok, message}
      {:error, message} -> {:error, message}
    end
  end
  defp respond(error), do: error

  defp start_tick, do: send EngineServer, :tick
end
