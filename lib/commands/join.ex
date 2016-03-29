defmodule Register do
  defstruct name: ""
end

defimpl Command, for: Register do

  def execute(command, world) do
    World.register(world, command.name)
  end

  def success(command, pid, %World{nests: nests, ants: ants}) do
    nest = Enum.find(nests, &(&1.name == command.name))

    message = %{
      type: :nest,
      location: nest.pos,
      food: nest.food,
      team: nest.name,
      id: nest.id,
      ants: ants |> Enum.filter(&(&1.nest_id == nest.id)) |> Enum.count
    }

    send pid, {:ok, message}
  end

  def failure(_, pid, _) do
    send pid, {:error, :name_taken}
  end
end
