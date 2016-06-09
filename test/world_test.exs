defmodule WorldTest do
  use ExUnit.Case, async: true

  test "registering creates a nest" do
    {:ok, world} = %World{} |> World.register("name")
    assert [%Nest{team: "name"}] = World.nests(world)
  end

  test "registering does not create duplicate " do
    {:ok, world} = %World{} |> World.register("name")
    assert World.register(world, "name") == {:error, :name_taken}
  end

  test "spawning an ant" do
    nest = %Nest{id: 1}
    {:ok, world} = %World{nests: [nest]} |> World.spawn_ant(nest.id)

    [ant] = world |> World.ants

    assert ant.nest_id == nest.id
  end

  test "spawned ants have unique ids" do
    nest = %Nest{}

    [ant_1, ant_2] =
      with {:ok, world} <- World.spawn_ant(%World{nests: [nest]}, nest.id),
           {:ok, world} <- World.spawn_ant(world, nest.id),
        do: world |> World.ants

    refute ant_1.id == ant_2.id
  end

  test "spawning errors when nest has no food" do
    nest = %Nest{food: 0}
    error = World.spawn_ant(%World{nests: [nest]}, nest.id)

    assert error == {:error, :insufficient_food}
  end

  test "spawning errors when name doesn't exist" do
    assert World.spawn_ant(%World{}, 1) == {:error, :unknown_nest}
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

  test "finding an ant" do
    ant_1 = %Ant{id: 1}
    ant_2 = %Ant{id: 2}
    world = %World{ants: [ant_1, ant_2]}

    assert World.ant(world, 1) == ant_1
  end

  test "finding a nest" do
    nest_1 = %Nest{id: 1, team: "me"}
    nest_2 = %Nest{id: 2, team: "you"}
    world = %World{nests: [nest_1, nest_2]}

    assert World.nest(world, "me") == nest_1
  end

  test "finding by id" do
    nest = %Nest{id: 1}
    ant = %Ant{id: 2}
    world = %World{ants: [ant], nests: [nest]}

    assert World.find(world, 1) == nest
    assert World.find(world, 2) == ant
  end

  test "get surroundings" do
    nest = %Nest{id: 1, pos: {0, 0}}
    ant = %Ant{id: 2, pos: {1, 0}}
    world = %World{ants: [ant], nests: [nest]}

    {:ok, %{e: found}} = World.surroundings(world, 1)

    assert found == [ant]
  end

  test "get surroundings can fail" do
    assert World.surroundings(%World{}, 1) == {:error, :id_not_found}
  end
end
