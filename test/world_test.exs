defmodule WorldTest do
  use ExUnit.Case

  test "registering creates a nest" do
    {:ok, world} = %World{} |> World.register("name")
    assert World.nests(world) == [%Nest{name: "name"}]
  end

  test "registering does not create duplicate " do
    {:ok, world} = %World{} |> World.register("name")
    assert World.register(world, "name") == {:error, :name_taken}
  end

  test "spawning an ant" do
    nest = %Nest{}
    {:ok, world} = %World{nests: [nest]} |> World.spawn(nest.id)

    assert World.ants(world) |> Enum.count == 1
  end

  test "spawned ants have unique ids" do
    nest = %Nest{}

    [ant_1, ant_2] =
      with {:ok, world} <- World.spawn(%World{nests: [nest]}, nest.id),
           {:ok, world} <- World.spawn(world, nest.id),
        do: world |> World.ants

    refute ant_1.id == ant_2.id
  end

  test "spawning errors when nest has no food" do
    nest = %Nest{food: 0}
    error = World.spawn(%World{nests: [nest]}, nest.id)

    assert error == {:error, :insufficient_food}
  end

  test "spawning errors when name doesn't exist" do
    assert World.spawn(%World{}, 1) == {:error, :unknown_nest}
  end

  test "moving an ant" do
    {:ok, world} = %World{ants: [%Ant{id: 1}]}
    |> World.move_ant(1, {0, 1})

    [ant] = world |> World.ants
    assert ant.pos == {0, 1}
  end

  test "moving errors when ant does not exist" do
    result = %World{} |> World.move_ant(1, {0, 1})
    assert result == {:error, :unknown_ant}
  end

  test "spawning food" do
    food = %World{} |> World.spawn_food({2, 3}) |> World.food
    assert food == [{2, 3}]
  end

  test "spawning multiple food" do
    food = %World{} |> World.spawn_food({2, 3}, 3) |> World.food
    assert food == [{2, 3}, {2, 3}, {2, 3}]
  end

  test "picking up food" do
    food = %World{}
    |> World.spawn_food({2, 3}, 3)
    |> World.pick_up_food({2, 3})
    |> World.food

    assert food == [{2, 3}, {2, 3}]
  end
end
