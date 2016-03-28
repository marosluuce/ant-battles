defmodule Move do
  defstruct ant_id: -1, direction: {0, 0}
end

defimpl Command, for: Move do
  def execute(%Move{ant_id: ant_id, direction: direction}, world) do
    World.move_ant(world, ant_id, direction)
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
