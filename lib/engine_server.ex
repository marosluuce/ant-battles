defmodule EngineServer do
  use GenServer

  @delay 1000

  def init(_), do: {:ok, %Engine{}}

  def handle_call({user, command}, {pid, _}, state) do
    case enqueue_instruction({user, pid, command}, state) do
      {:ok, new_state} -> {:reply, {:ok, :enqueued}, new_state}
      error            -> {:reply, error, state}
    end
  end

  def handle_cast(:tick, state) do
    {:noreply, %{state | instructions: [], world: update(state)}}
  end

  def handle_info(:tick, state) do
    GenServer.cast(__MODULE__, :tick)
    Process.send_after(self(), :tick, @delay)

    {:noreply, state}
  end

  defp update(%Engine{world: world, instructions: instructions}) do
    {results, new_world} = Enum.map_reduce(instructions, world, &execute/2)

    Enum.each(results, &(notify(&1, new_world)))

    new_world
  end

  defp execute(instruction = {_, _, command}, world) do
    case Command.execute(command, world) do
      {:ok, new_world} -> {{:ok, instruction}, new_world}
      _                -> {{:error, instruction}, world}
    end
  end

  defp notify({:ok, {_, pid, command}}, world), do: Command.success(command, pid, world)
  defp notify({:error, {_, pid, command}}, world), do: Command.failure(command, pid, world)

  defp enqueue_instruction({user, pid, command}, state) do
    if unique_user?(state.instructions, user) do
      {:error, :already_enqueued}
    else
      {:ok, append_instruction(state, {user, pid, command})}
    end
  end

  defp append_instruction(state, instruction) do
    %{state | instructions: state.instructions ++ [instruction]}
  end

  defp unique_user?(instructions, user) do
    instructions
    |> Enum.map(fn {user, _, _} -> user end)
    |> Enum.member?(user)
  end
end
