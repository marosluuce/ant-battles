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
    {:ok, world} = %World{} |> World.register("name")
    {:ok, world} = world |> World.spawn("name")

    assert World.ants(world) |> Enum.count == 1
  end

  test "spawned ants have unique ids" do
    {:ok, world} = %World{} |>  World.register("name")

    [ant_1, ant_2] =
      with {:ok, world} <- World.spawn(world, "name"),
           {:ok, world} <- World.spawn(world, "name"),
        do: World.ants(world)

    refute ant_1.id == ant_2.id
  end

  test "spawning errors when nest has no food" do
    world = %World{nests: [%Nest{food: 0, name: "name"}]}
    error = World.spawn(world, "name")

    assert error == {:error, "Nest name has insufficient food to spawn ant."}
  end

  test "spawning errors when name doesn't exist" do
    assert World.spawn(%World{}, "name") == {:error, "Nest name does not exist."}
  end

  test "moving an ant" do
    {:ok, world} = %World{ants: [%Ant{id: 1}]}
    |> World.move_ant(1, {0, 1})

    [ant] = world |> World.ants
    assert ant.pos == {0, 1}
  end

  test "moving errors when ant does not exist" do
    {:error, message} = %World{} |> World.move_ant(1, {0, 1})
    assert message == "Ant 1 does not exist."
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
