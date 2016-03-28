defmodule SpawnAnt do
  defstruct nest_id: -1
end

defimpl Command, for: SpawnAnt do
  def execute(command, world) do
    World.spawn(world, command.nest_id)
  end

  def success(_, pid, _) do
    send pid, {:ok, :todo}
  end

  def failure(_, pid, _) do
    send pid, {:error, :todo}
  end
end
