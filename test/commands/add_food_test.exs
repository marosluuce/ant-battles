defmodule AddFoodTest do
  use ExUnit.Case, async: true

  alias AntBattles.Food
  alias AntBattles.World
  alias AntBattles.Commands.Command
  alias AntBattles.Commands.AddFood

  test "it adds food to the world" do
    {:ok, world} = Command.execute(%AddFood{location: {0, 0}, quantity: 5}, %World{})

    assert [%Food{pos: {0, 0}, quantity: 5}] = world |> World.food
  end

  test "success sends a message" do
    assert {:ok, :added_food} = Command.success(%AddFood{}, %World{})
  end

  test "failure sends a message" do
    assert {:error, :failed_to_add_food} = Command.failure(%AddFood{}, %World{})
  end
end
