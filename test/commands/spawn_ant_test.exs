defmodule SpawnAntTest do
  use ExUnit.Case, async: true

  test "it spawns an ant" do
    command = %SpawnAnt{nest_id: 1}
    world = %World{nests: [%Nest{id: 1, food: 1}]}

    {:ok, updated_world} = Command.execute(command, world)

    [ant] = updated_world |> World.ants
    assert ant.nest_id() == 1
  end

  test "it sends a success message" do
    command = %SpawnAnt{nest_id: 2}
    ant = %Ant{id: 1, nest_id: 2, pos: {0, 0}, team: "me"}
    world = %World{ants: [ant]}

    Command.success(command, self(), world)

    message = Message.details(ant, world)
    assert_received {:ok, ^message}
  end

  test "it sends a failure message" do
    Command.failure(%SpawnAnt{}, self(), %World{})

    assert_received {:error, :insufficient_food}
  end
end
