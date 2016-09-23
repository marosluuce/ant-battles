defmodule AntBattles.Commands.AddFood do
  defstruct location: {0, 0}, quantity: 0
end

defimpl AntBattles.Commands.Command, for: AntBattles.Commands.AddFood do
  alias AntBattles.World

  def execute(command, world) do
    {:ok, World.spawn_food(world, command.location, command.quantity)}
  end

  def success(_, _), do: {:ok, :added_food}

  def failure(_, _), do: {:error, :failed_to_add_food}
end
