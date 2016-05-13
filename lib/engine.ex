defmodule Engine do
  defstruct delay: 1000, instructions: [], world: %World{}

  def start_link(delay) do
    result = GenServer.start_link(EngineServer, delay, name: EngineServer)
    start_tick()
    result
  end

  def join(user, team), do: execute(user, %Join{team: team})

  def spawn_ant(user, nest_id), do: execute(user, %SpawnAnt{nest_id: nest_id})

  def move_ant(user, ant_id, direction) do
    execute(user, %MoveAnt{ant_id: ant_id, velocity: Commands.move(direction)})
  end

  def look(user, ant_id), do: execute(user, %Look{ant_id: ant_id})

  def info(user, id), do: execute(user, %Info{id: id})

  defp execute(user, command) do
    user
    |> run(command)
    |> respond
  end

  defp run(user, command), do: GenServer.call(EngineServer, {user, command})

  defp respond({:ok, _}) do
    receive do
      {:ok, message} -> {:ok, message}
      {:error, message} -> {:error, message}
    end
  end
  defp respond(error), do: error

  defp start_tick, do: send EngineServer, :tick
end
