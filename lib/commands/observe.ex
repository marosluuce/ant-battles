defmodule Observe do
  defstruct pid: -1
end

defimpl Command, for: Observe do
  def id(%Observe{pid: pid}), do: pid

  def execute(_, world), do: {:ok, world}

  def success(_, pid, world) do
    observed = %{
      ants: ants(world),
      food: food(world)
    }

    send pid, {:ok, observed}
  end

  def failure(_, pid, _), do: send pid, {:error, :failed_to_observe}

  defp ants(world) do
    Enum.map(world.ants, &(Message.details(&1, world)))
  end

  defp food(world) do
    Enum.map(world.food, &Tuple.to_list/1)
  end
end

