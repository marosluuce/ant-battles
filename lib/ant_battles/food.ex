defmodule AntBattles.Food do
  defstruct pos: {0, 0}, quantity: -1

  def create(location, quantity) do
    %__MODULE__{pos: location, quantity: quantity}
  end
end
