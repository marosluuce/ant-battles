defmodule Register do
  defstruct name: ""
end

defimpl Command, for: Register do

  def execute(command, world) do
    result = World.register(world, command.name)
    case result do
      {:ok, new_world} -> new_world
      {:error, _} -> world
    end
  end

  def notify(command, pid, %World{nests: nests}) do
    nest = Enum.find(nests, &(&1.name == command.name))
    send pid, {:ok, %{position: nest.pos, food: nest.food, id: nest.id}}
  end
end
