defmodule MoveAntTest do
  use ExUnit.Case, async: true

  test "it moves an ant" do
    command = %MoveAnt{ant_id: 1, velocity: {0, 1}}
    world = %World{ants: [%Ant{id: 1, pos: {2, 3}}]}

    {:ok, updated_world} = Command.execute(command, world)

    [ant] = updated_world |> World.ants
    assert ant.pos == {2, 4}
  end

  test "it sends a success message" do
    command = %MoveAnt{ant_id: 1}
    ant = %Ant{id: 1, pos: {2, 4}}
    world = %World{ants: [ant]}

    Command.success(command, self(), world)

    message = Message.with_surroundings(ant, world)
    assert_received {:ok, ^message}
  end

  test "it sends a failure message" do
    Command.failure(%MoveAnt{ant_id: 1}, self(), %World{})

    assert_received {:error, :invalid_id}
  end
end
