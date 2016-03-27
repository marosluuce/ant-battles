defmodule EngineServer do
  use GenServer

  @delay 1000

  def init(_), do: {:ok, %Engine{}}

  def handle_call({user, command}, {pid, _}, state) do
    case enqueue_command({user, pid, command}, state) do
      {:ok, new_state} -> {:reply, {:ok, :enqueued}, new_state}
      error            -> {:reply, error, state}
    end
  end

  def handle_cast(:tick, state), do: {:noreply, %{state | commands: [], world: update(state)}}

  def handle_info(:tick, state) do
    GenServer.cast(__MODULE__, :tick)
    Process.send_after(self(), :tick, @delay)

    {:noreply, state}
  end

  defp update(%Engine{world: world, commands: commands}) do
    new_world = Enum.reduce(commands, world, &execute/2)

    Enum.each(commands, &(notify(&1, new_world)))

    new_world
  end

  defp execute({_, _, command}, world), do: Command.execute(command, world)

  defp notify({_, pid, command}, world), do: Command.notify(command, pid, world)

  defp enqueue_command({user, pid, command}, state) do
    if unique_user?(state.commands, user) do
      {:error, :already_enqueued}
    else
      {:ok, append_command(state, {user, pid, command})}
    end
  end

  defp append_command(state, command), do: %{state | commands: state.commands ++ [command]}

  defp unique_user?(commands, user) do
    commands
    |> Enum.map(fn {user, _, _} -> user end)
    |> Enum.member?(user)
  end
end
