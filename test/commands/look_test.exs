defmodule LookTest do
  use ExUnit.Case, async: true

  setup do
    ant = %Ant{id: 1}
    world = %World{ants: [ant]}

    [ant: ant, world: world]
  end

  test "looking succeeds when the ant exists", context do
    assert {:ok, context[:world]} == Command.execute(%Look{ant_id: 1}, context[:world])
  end

  test "looking errors when the ant does not exist" do
    assert {:error, :invalid_id} == Command.execute(%Look{ant_id: 1}, %World{})
  end

  test "sending a success message", context do
    message = Message.with_surroundings(context[:ant], context[:world])

    assert {:ok, message} == Command.success(%Look{ant_id: 1}, context[:world])
  end

  test "sending a failure message" do
    assert {:error, :invalid_id} = Command.failure(%Look{}, %World{})
  end
end
