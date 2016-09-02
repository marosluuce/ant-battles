defmodule AddFood do
  defstruct location: {0, 0}, quantity: 0
end

defimpl Command, for: AddFood do
  def execute(%AddFood{location: location, quantity: quantity}, world) do
    {:ok, World.spawn_food(world, location, quantity)}
  end

  def success(_, _), do: {:ok, :added_food}

  def failure(_, _), do: {:error, :failed_to_add_food}
end
