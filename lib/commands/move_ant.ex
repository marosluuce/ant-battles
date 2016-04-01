defmodule MoveAnt do
  defstruct ant_id: -1, velocity: {0, 0}
end

defimpl Command, for: MoveAnt do
  def execute(%MoveAnt{ant_id: ant_id, velocity: velocity}, world) do
    World.move_ant(world, ant_id, velocity)
  end

  def success(command, pid, %World{ants: ants}) do
    ant = Enum.find(ants, &(&1.id == command.ant_id))
    {x, y} = ant.pos

    send pid, {:ok, "Ant-#{command.ant_id} now at (#{x}, #{y})"}
  end

  def failure(_, pid, _) do
    send pid, {:error, :invalid_id}
  end
end
