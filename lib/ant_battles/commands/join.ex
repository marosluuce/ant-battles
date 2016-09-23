defmodule AntBattles.Commands.Join do
  defstruct team: ""
end

defimpl AntBattles.Commands.Command, for: AntBattles.Commands.Join do
  alias AntBattles.World
  alias AntBattles.Message

  def execute(command, world), do: World.register(world, command.team)

  def success(command, world) do
    nest = World.nest(world, command.team)

    {:ok, Message.details(nest)}
  end

  def failure(_, _), do: {:error, :name_taken}
end
