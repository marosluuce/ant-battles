defmodule IntoTest do
  use ExUnit.Case, async: true

  test "succeeds when id exists in world" do
    nest = %Nest{id: 1}
    world = %World{nests: [nest]}

    assert Command.execute(%Info{id: 1}, world) == {:ok, world}
  end

  test "fails when id exists in world" do
    assert Command.execute(%Info{}, %World{}) == {:error, :invalid_id}
  end

  test "sends a success message" do
    nest = %Nest{id: 1}
    world = %World{nests: [nest]}

    Command.success(%Info{id: 1}, self(), world)

    message = Message.details(nest, world)
    assert_received {:ok, ^message}
  end

  test "sends a failure message" do
    Command.failure(%Info{}, self(), %World{})

    assert_received {:error, :invalid_id}
  end
end
