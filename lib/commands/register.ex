defmodule Register do
  defstruct name: ""
end

defimpl Command, for: Register do

  def execute(command, world) do
    World.register(world, command.name)
  end

  def success(command, pid, %World{nests: nests}) do
    nest = Enum.find(nests, &(&1.name == command.name))
    send pid, {:ok, %{position: nest.pos, food: nest.food, id: nest.id}}
  end

  def failure(_, pid, _) do
    send pid, {:error, :name_taken}
  end
end
