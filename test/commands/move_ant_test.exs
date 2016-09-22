defmodule MoveAntTest do
  use ExUnit.Case, async: true

  alias AntBattles.Ant
  alias AntBattles.Message
  alias AntBattles.World
  alias AntBattles.Commands.Command
  alias AntBattles.Commands.MoveAnt

  test "it moves an ant" do
    command = %MoveAnt{ant_id: 1, velocity: {0, 1}}
    world = %World{ants: [%Ant{id: 1, pos: {2, 3}}]}

    {:ok, updated_world} = Command.execute(command, world)

    [ant] = updated_world.ants
    assert ant.pos == {2, 4}
  end

  test "it sends a success message" do
    command = %MoveAnt{ant_id: 1}
    ant = %Ant{id: 1, pos: {2, 4}}
    world = %World{ants: [ant]}
    message = Message.with_surroundings(ant, world)

    assert {:ok, ^message} = Command.success(command, world)
  end

  test "it sends a failure message" do
    assert {:error, :invalid_id} = Command.failure(%MoveAnt{ant_id: 1}, %World{})
  end
end
