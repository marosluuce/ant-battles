defmodule AntBattles.Commands.Observe do
  defstruct id: -1
end

defimpl AntBattles.Commands.Command, for: AntBattles.Commands.Observe do
  alias AntBattles.Message
  alias AntBattles.World

  def execute(_, world), do: {:ok, world}

  def success(_, world) do
    observed = %{
      ants: ants(world),
      food: food(world),
      nests: nests(world)
    }

    {:ok, observed}
  end

  def failure(_, _), do: {:error, :failed_to_observe}

  defp ants(world) do
    world.ants
    |> Map.values
    |> Enum.map(&Message.details/1)
  end

  defp food(world) do
    world
    |> World.food
    |> Enum.map(&(&1.pos))
    |> Enum.map(&Tuple.to_list/1)
  end

  defp nests(world) do
    world.nests
    |> Map.values
    |> Enum.map(&Message.details/1)
  end
end
