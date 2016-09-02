defmodule MoveAnt do
  defstruct ant_id: -1, velocity: {0, 0}
end

defimpl Command, for: MoveAnt do
  def execute(%MoveAnt{ant_id: ant_id, velocity: velocity}, world) do
    World.move_ant(world, ant_id, velocity)
  end

  def success(%MoveAnt{ant_id: ant_id}, world) do
    message = world
    |> World.ant(ant_id)
    |> Message.with_surroundings(world)

    {:ok, message}
  end

  def failure(_, _), do: {:error, :invalid_id}
end
