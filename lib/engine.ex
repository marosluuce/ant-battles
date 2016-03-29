defmodule Engine do
  defstruct instructions: [], world: %World{}

  def start do
    GenServer.start(EngineServer, [], name: EngineServer)
    start_tick()
  end

  def start_link do
    GenServer.start_link(EngineServer, [], name: EngineServer)
    start_tick()
  end

  def join(user, name) do
    user
    |> execute(%Join{name: name})
    |> respond
  end

  def spawn_ant(user, nest_id) do
    user
    |> execute(%SpawnAnt{nest_id: nest_id})
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
