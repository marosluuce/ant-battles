defmodule LookTest do
  use ExUnit.Case, async: true

  test "looking succeeds when the ant exists" do
    ant = %Ant{id: 1}
    world = %World{ants: [ant]}

    assert Command.execute(%Look{ant_id: 1}, world) == {:ok, world}
  end

  test "looking errors when the ant does not exist" do
    assert Command.execute(%Look{ant_id: 1}, %World{}) == {:error, :invalid_id}
  end

  test "sending a success message" do
    ant = %Ant{id: 1}
    world = %World{ants: [ant]}

    Command.success(%Look{ant_id: 1}, self(), world)

    message = Message.with_surroundings(ant, world)
    assert_received {:ok, ^message}
  end

  test "sending a failure message" do
    Command.failure(%Look{}, self(), %World{})

    assert_received {:error, :invalid_id}
  end
end
