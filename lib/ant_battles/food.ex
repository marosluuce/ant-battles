defmodule AntBattles.Food do
  defstruct pos: {0, 0}, quantity: -1

  def from_map(food) do
    Enum.filter_map(
      food,
      fn {_, quantity} -> quantity > 0 end,
      fn {location, quantity} -> %__MODULE__{pos: location, quantity: quantity} end
    )
  end
end
