defmodule AddFoodTest do
  use ExUnit.Case, async: true

  alias AntBattles.Food
  alias AntBattles.Stores
  alias AntBattles.Commands.Command
  alias AntBattles.Commands.AddFood

  setup do
    [name: AntBattles.WorldHelper.create()]
  end

  test "it adds food to the world", context do
    name = context[:name]
    :ok = Command.execute(%AddFood{location: {0, 0}, quantity: 5}, name)

    assert [%Food{pos: {0, 0}, quantity: 5}] = Stores.Food.all(name)
  end

  test "success sends a message", context do
    assert {:ok, :added_food} = Command.success(%AddFood{}, context[:name])
  end

  test "failure sends a message", context do
    assert {:error, :failed_to_add_food} = Command.failure(%AddFood{}, context[:name])
  end
end
