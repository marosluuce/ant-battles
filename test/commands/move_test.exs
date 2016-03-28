defmodule MoveTest do
  use ExUnit.Case

  test "it moves an ant" do
    command = %Move{ant_id: 1, direction: {0, 1}}
    world = %World{ants: [%Ant{id: 1, pos: {2, 3}}]}

    {:ok, updated_world} = Command.execute(command, world)

    [ant] = updated_world |> World.ants
    assert ant.pos == {2, 4}
  end

  test "it sends a success message" do
    command = %Move{ant_id: 1}
    world = %World{ants: [%Ant{id: 1, pos: {2, 4}}]}

    Command.success(command, self(), world)

    assert_received {:ok, "Ant-1 now at (2, 4)"}
  end

  test "it sends a failure message" do
    command = %Move{ant_id: 1}

    Command.failure(command, self(), %World{})

    assert_received {:error, :invalid_id}
  end
end
