defmodule Engine do
  defstruct delay: 1000, instructions: [], world: %World{}

  def start(delay) do
    GenServer.start(EngineServer, delay, name: EngineServer)
    start_tick()
  end

  def start_link(delay) do
    GenServer.start_link(EngineServer, delay, name: EngineServer)
    start_tick()
  end

  def join(user, team) do
    user
    |> execute(%Join{team: team})
    |> respond
  end

  def spawn_ant(user, nest_id) do
    user
    |> execute(%SpawnAnt{nest_id: nest_id})
    |> respond
  end

  def move_ant(user, ant_id, direction) do
    velocity = Commands.move(direction)

    user
    |> execute(%MoveAnt{ant_id: ant_id, velocity: velocity})
    |> respond
  end

  def look(user, ant_id) do
    user
    |> execute(%Look{ant_id: ant_id})
    |> respond
  end

  def info(user, id) do
    user
    |> execute(%Info{id: id})
    |> respond
  end

  defp execute(user, command), do: GenServer.call(EngineServer, {user, command})

  defp respond({:ok, _}) do
    receive do
      result -> result
    end
  end

  defp respond(error), do: error

  defp start_tick, do: send EngineServer, :tick
end
