defmodule EngineServer do
  use GenServer

  def init(engine), do: {:ok, engine}

  def handle_call(:get_world, _, state = %Engine{world: world}) do
    {:reply, world, state}
  end

  def handle_call({:run, command}, _, state) do
    case Command.execute(command, state.world) do
      {:ok, new_world} ->
        {:reply, Command.success(command, new_world), %{state | world: new_world}}
      _                ->
        {:reply, Command.failure(command, state.world), state}
    end
  end
end
