defmodule MoveAnt do
  defstruct ant_id: -1, velocity: {0, 0}
end

defimpl Command, for: MoveAnt do
  def execute(%MoveAnt{ant_id: ant_id, velocity: velocity}, world) do
    World.move_ant(world, ant_id, velocity)
  end

  def success(%MoveAnt{ant_id: ant_id}, pid, world) do
    message = world
    |> World.ant(ant_id)
    |> Message.details(world)

    send pid, {:ok, message}
  end

  def failure(_, pid, _), do: send pid, {:error, :invalid_id}
end
