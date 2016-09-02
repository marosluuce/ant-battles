defmodule SpawnAnt do
  defstruct nest_id: -1
end

defimpl Command, for: SpawnAnt do
  def execute(%SpawnAnt{nest_id: nest_id}, world), do: World.spawn_ant(world, nest_id)

  def success(%SpawnAnt{nest_id: nest_id}, world) do
    message = world
    |> World.newest_ant(nest_id)
    |> Message.with_surroundings(world)

    {:ok, message}
  end

  def failure(_, _), do: {:error, :insufficient_food}
end
