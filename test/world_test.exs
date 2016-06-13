defmodule WorldTest do
  use ExUnit.Case, async: true

  test "can create a new world" do
    assert %World{} = World.new([])
  end

  test "a new world has food" do
    world = World.new(food_stacks: 1, food_stack_size: 10)

    assert [{_, _}] = world |> World.food |> Map.keys
    assert [10] = world |> World.food |> Map.values
  end

  test "registering creates a nest" do
    {:ok, world} = World.register(%World{}, "name")
    assert [%Nest{team: "name"}] = World.nests(world)
  end

  test "registering does not create duplicate " do
    {:ok, world} = World.register(%World{}, "name")
    assert {:error, :name_taken} = World.register(world, "name")
  end

  test "spawning an ant" do
    {:ok, world} = %World{nests: [%Nest{id: 1}]} |> World.spawn_ant(1)

    assert [%Ant{nest_id: 1}] = world |> World.ants
  end

  test "spawned ants have unique ids" do
    {:ok, world} = World.spawn_ant(%World{nests: [%Nest{id: 1}]}, 1)
    {:ok, world} = World.spawn_ant(world, 1)

    [ant_1, ant_2] = world |> World.ants

    refute ant_1.id == ant_2.id
  end

  test "spawning errors when nest has no food" do
    nest = %Nest{food: 0}
    error = World.spawn_ant(%World{nests: [nest]}, nest.id)

    assert error == {:error, :insufficient_food}
  end

  test "spawning errors when name doesn't exist" do
    assert {:error, :unknown_nest} = World.spawn_ant(%World{}, 1)
  end

  test "moving an ant" do
    {:ok, world} = %World{ants: [%Ant{id: 1}]}
    |> World.move_ant(1, {0, 1})

    assert [%Ant{pos: {0, 1}}] = world |> World.ants
  end

  test "moving an ant over food picks up food" do
    world = %World{ants: [%Ant{id: 1, pos: {0, 0}}]}
    world = World.spawn_food(world, {1, 1}, 1)
    {:ok, world} = World.move_ant(world, 1, {1, 1})

    assert [%Ant{id: 1, pos: {1, 1}, has_food: true}] = world |> World.ants
    assert %{{1, 1} => 0} = world |> World.food
  end

  test "moving an ant with food over a nest drops food" do
    world = %World{
      ants: [%Ant{id: 2, nest_id: 1, pos: {0, 1}, has_food: true}],
      nests: [%Nest{id: 1, food: 0}]
    }

    {:ok, world} = World.move_ant(world, 2, {0, -1})

    assert [%Ant{has_food: false}] = world |> World.ants
    assert [%Nest{food: 1}] = world |> World.nests
  end

  test "moving errors when ant does not exist" do
    assert {:error, :unknown_ant} = %World{} |> World.move_ant(1, {0, 1})
  end

  test "spawning food" do
    food = %World{} |> World.spawn_food({2, 3}) |> World.food
    assert %{{2, 3} => 1} = food
  end

  test "spawning multiple food" do
    food = %World{} |> World.spawn_food({2, 3}, 3) |> World.food
    assert %{{2, 3} => 3} = food
  end

  test "picking up food" do
    food = %World{}
    |> World.spawn_food({2, 3}, 3)
    |> World.pick_up_food({2, 3})
    |> World.food

    assert %{{2, 3} => 2} = food
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
