defmodule AntBattles.Commands.Observe do
  defstruct id: -1
end

defimpl AntBattles.Commands.Command, for: AntBattles.Commands.Observe do
  alias AntBattles.Message
  alias AntBattles.Stores

  def execute(_, _), do: :ok

  def success(_, name) do
    observed = %{
      ants: ants(name),
      food: food(name),
      nests: nests(name)
    }

    {:ok, observed}
  end

  def failure(_, _), do: {:error, :failed_to_observe}

  defp ants(name) do
    name
    |> Stores.Ants.all
    |> Enum.map(&Message.details/1)
  end

  defp food(name) do
    name
    |> Stores.Food.all
    |> Enum.map(&(&1.pos))
    |> Enum.map(&Tuple.to_list/1)
  end

  defp nests(name) do
    name
    |> Stores.Nests.all
    |> Enum.map(&Message.details/1)
  end
end
