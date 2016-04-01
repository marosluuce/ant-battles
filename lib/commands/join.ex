defmodule Join do
  defstruct team: ""
end

defimpl Command, for: Join do

  def execute(command, world) do
    World.register(world, command.team)
  end

  def success(command, pid, world) do
    nest = world
    |> World.nests
    |> Enum.find(&(&1.team == command.team))

    send pid, {:ok, Message.details(nest, world)}
  end

  def failure(_, pid, _) do
    send pid, {:error, :name_taken}
  end
end
