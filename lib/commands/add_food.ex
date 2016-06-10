defmodule AddFood do
  defstruct location: {0, 0}, quantity: 0
end

defimpl Command, for: AddFood do
  def id(%AddFood{location: location}), do: location

  def execute(%AddFood{location: location, quantity: quantity}, world) do
    {:ok, World.spawn_food(world, location, quantity)}
  end

  def success(_, pid, _), do: send pid, {:ok, :added_food}

  def failure(_, pid, _), do: send pid, {:error, :failed_to_add_food}
end
