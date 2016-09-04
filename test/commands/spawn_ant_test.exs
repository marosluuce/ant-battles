defmodule SpawnAntTest do
  use ExUnit.Case, async: true

  test "it spawns an ant" do
    command = %SpawnAnt{nest_id: 1}
    world = %World{nests: [%Nest{id: 1, food: 1}]}

    {:ok, updated_world} = Command.execute(command, world)

    [ant] = updated_world.ants
    assert ant.nest_id() == 1
  end

  test "it sends a success message" do
    command = %SpawnAnt{nest_id: 2}
    ant = %Ant{id: 1, nest_id: 2, pos: {0, 0}, team: "me"}
    world = %World{ants: [ant]}
    message = Message.with_surroundings(ant, world)

    assert {:ok, ^message} = Command.success(command, world)
  end

  test "it sends a failure message" do
    assert {:error, :insufficient_food} = Command.failure(%SpawnAnt{}, %World{})
  end
end
