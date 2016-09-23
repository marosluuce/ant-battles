defmodule AntBattles.Commands.Look do
  defstruct ant_id: -1
end

defimpl AntBattles.Commands.Command, for: AntBattles.Commands.Look do
  alias AntBattles.World
  alias AntBattles.Message

  def execute(command, world) do
    not_found = world
    |> World.ant(command.ant_id)
    |> is_nil

    if not_found do
      {:error, :invalid_id}
    else
      {:ok, world}
    end
  end

  def success(command, world) do
    message = world
    |> World.ant(command.ant_id)
    |> Message.with_surroundings(world)

    {:ok, message}
  end

  def failure(_, _) do
    {:error, :invalid_id}
  end
end
