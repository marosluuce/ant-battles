defmodule SpawnAnt do
  defstruct nest_id: -1
end

defimpl Command, for: SpawnAnt do
  def id(%SpawnAnt{nest_id: nest_id}), do: nest_id

  def execute(%SpawnAnt{nest_id: nest_id}, world), do: World.spawn_ant(world, nest_id)

  def success(%SpawnAnt{nest_id: nest_id}, pid, world) do
    message = world
    |> World.newest_ant(nest_id)
    |> Message.with_surroundings(world)

    send pid, {:ok, message}
  end

  def failure(_, pid, _), do: send pid, {:error, :insufficient_food}
end
