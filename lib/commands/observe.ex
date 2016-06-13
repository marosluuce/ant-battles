defmodule Observe do
  defstruct pid: -1
end

defimpl Command, for: Observe do
  def id(%Observe{pid: pid}), do: pid

  def execute(_, world), do: {:ok, world}

  def success(_, pid, world) do
    observed = %{
      ants: ants(world),
      food: food(world),
      nests: nests(world)
    }

    send pid, {:ok, observed}
  end

  def failure(_, pid, _), do: send pid, {:error, :failed_to_observe}

  defp ants(world) do
    world
    |> World.ants
    |> Enum.map(&Message.details/1)
  end

  defp food(world) do
    world
    |> World.food
    |> Enum.filter(fn {_, quantity} -> quantity > 0 end)
    |> Enum.map(fn f -> Kernel.elem(f, 0) end)
    |> Enum.map(&Tuple.to_list/1)
  end

  defp nests(world) do
    world
    |> World.nests
    |> Enum.map(&Message.details/1)
  end
end

