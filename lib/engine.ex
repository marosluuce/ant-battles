defmodule Engine do
  defstruct commands: [], world: %World{}

  def start do
    GenServer.start(EngineServer, [], name: EngineServer)
    start_tick()
  end

  def start_link do
    GenServer.start_link(EngineServer, [], name: EngineServer)
    start_tick()
  end

  def register(user, name) do
    user
    |> execute(%Register{name: name})
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
