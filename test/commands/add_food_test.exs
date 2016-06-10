defmodule AddFoodTest do
  use ExUnit.Case, async: true

  test "it adds food to the world" do
    {:ok, world} = Command.execute(%AddFood{location: {0, 0}, quantity: 5}, %World{})

    assert %{{0, 0} => 5} = world |> World.food
  end

  test "success sends a message" do
    Command.success(%AddFood{}, self(), %World{})

    assert_received {:ok, :added_food}
  end

  test "failure sends a message" do
    Command.failure(%AddFood{}, self(), %World{})

    assert_received {:error, :failed_to_add_food}
  end
end
