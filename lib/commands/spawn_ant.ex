defmodule SpawnAnt do
  defstruct nest_id: -1
end

defimpl Command, for: SpawnAnt do
  def execute(%SpawnAnt{nest_id: nest_id}, world) do
    World.spawn_ant(world, nest_id)
  end

  def success(%SpawnAnt{nest_id: nest_id}, pid, world) do
    [ant | _] = world
    |> World.ants
    |> Enum.filter(&(&1.nest_id == nest_id))

    send pid, {:ok, Message.details(ant, world)}
  end

  def failure(_, pid, _) do
    send pid, {:error, :insufficient_food}
  end
end
