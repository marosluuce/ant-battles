defmodule Move do
  defstruct ant_id: -1, direction: {0, 0}
end

defimpl Command, for: Move do

  def execute(%Move{ant_id: ant_id, direction: direction}, world) do
    case World.move_ant(world, ant_id, direction) do
      {:ok, new_world} -> new_world
      {:error, _} -> world
    end
  end

  def notify(command, pid, %World{ants: ants}) do
    ant = Enum.find(ants, &(&1.id == command.ant_id))
    {x, y} = ant.pos

    send pid, {:ok, "Ant-#{command.ant_id} now at (#{x}, #{y})"}
  end
end
