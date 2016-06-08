defmodule Look do
  defstruct ant_id: -1
end

defimpl Command, for: Look do
  def id(%Look{ant_id: ant_id}), do: ant_id

  def execute(%Look{ant_id: ant_id}, world) do
    not_found = world
    |> World.ant(ant_id)
    |> is_nil

    if not_found do
      {:error, :invalid_id}
    else
      {:ok, world}
    end
  end

  def success(%Look{ant_id: ant_id}, pid, world) do
    message = world
    |> World.ant(ant_id)
    |> Message.with_surroundings(world)

    send pid, {:ok, message}
  end

  def failure(_, pid, _) do
    send pid, {:error, :invalid_id}
  end
end
