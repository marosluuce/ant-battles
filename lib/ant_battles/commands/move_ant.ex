defmodule AntBattles.Commands.MoveAnt do
  defstruct ant_id: -1, velocity: {0, 0}
end

defimpl AntBattles.Commands.Command, for: AntBattles.Commands.MoveAnt do
  alias AntBattles.World
  alias AntBattles.Message

  def execute(command, world) do
    World.move_ant(world, command.ant_id, command.velocity)
  end

  def success(command, world) do
    message = world
    |> World.ant(command.ant_id)
    |> Message.with_surroundings(world)

    {:ok, message}
  end

  def failure(_, _), do: {:error, :invalid_id}
end
