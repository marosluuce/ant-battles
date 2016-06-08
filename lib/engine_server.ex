defmodule EngineServer do
  use GenServer

  def init(delay), do: {:ok, %Engine{delay: delay}}

  def handle_call(:get_world, _, state = %Engine{world: world}) do
    {:reply, world, state}
  end

  def handle_call({:enqueue, command}, {pid, _}, state) do
    {pid, command}
    |> enqueue_instruction(state)
    |> send_enqueue_response(state)
  end

  defp send_enqueue_response({:ok, new_state}, _), do: {:reply, {:ok, :enqueued}, new_state}
  defp send_enqueue_response(error, state), do: {:reply, error, state}

  def handle_cast(:tick, state), do: {:noreply, %{state | instructions: [], world: update(state)}}

  def handle_info(:tick, state) do
    GenServer.cast(__MODULE__, :tick)
    Process.send_after(self(), :tick, state.delay)

    {:noreply, state}
  end

  defp update(%Engine{world: world, instructions: instructions}) do
    {results, new_world} = Enum.map_reduce(instructions, world, &execute/2)

    Enum.each(results, &(notify(&1, new_world)))

    new_world
  end

  defp execute(instruction = {_, command}, world) do
    case Command.execute(command, world) do
      {:ok, new_world} -> {{:ok, instruction}, new_world}
      _                -> {{:error, instruction}, world}
    end
  end

  defp notify({:ok, {pid, command}}, world), do: Command.success(command, pid, world)
  defp notify({:error, {pid, command}}, world), do: Command.failure(command, pid, world)

  defp enqueue_instruction(instruction, state) do
    if exists?(state.instructions, instruction) do
      {:error, :already_enqueued}
    else
      {:ok, append_instruction(state, instruction)}
    end
  end

  defp append_instruction(state, instruction) do
    %{state | instructions: state.instructions ++ [instruction]}
  end

  defp exists?(instructions, {_, command}) do
    instructions
    |> Enum.map(&(elem(&1, 1)))
    |> Enum.map(&Command.id/1)
    |> Enum.member?(Command.id(command))
  end
end
