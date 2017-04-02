defmodule AntBattles.Commands.AddFood do
  defstruct location: {0, 0}, quantity: 0
end

defimpl AntBattles.Commands.Command, for: AntBattles.Commands.AddFood do
  alias AntBattles.Stores.Food

  def execute(command, name) do
    Food.add_food(name, command.location, command.quantity)
  end

  def success(_, _), do: {:ok, :added_food}

  def failure(_, _), do: {:error, :failed_to_add_food}
end
