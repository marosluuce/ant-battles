defmodule AntBattles.Commands.SpawnAnt do
  defstruct nest_id: -1
end

defimpl AntBattles.Commands.Command, for: AntBattles.Commands.SpawnAnt do
  alias AntBattles.World
  alias AntBattles.Message

  def execute(command, world), do: World.spawn_ant(world, command.nest_id)

  def success(command, world) do
    message = world
    |> World.newest_ant(command.nest_id)
    |> Message.with_surroundings(world)

    {:ok, message}
  end

  def failure(_, _), do: {:error, :insufficient_food}
end
