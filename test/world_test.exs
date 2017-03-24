defmodule WorldTest do
  use ExUnit.Case, async: true

  alias AntBattles.Ant
  alias AntBattles.Food
  alias AntBattles.Nest
  alias AntBattles.World

  test "can create a new world" do
    assert %World{} = World.new([food_stacks: 0, food_stack_size: 0])
  end

  test "a new world has food" do
    world = World.new(food_stacks: 1, food_stack_size: 10)

    assert [%Food{quantity: 10}] = World.food(world)
  end

  test "registering creates a nest" do
    {:ok, world} = World.register(%World{}, "name")
    assert [%Nest{team: "name"}] = Map.values(world.nests)
  end

  test "registering does not create duplicate " do
    {:ok, world} = World.register(%World{}, "name")
    assert {:error, :name_taken} = World.register(world, "name")
  end

  test "spawning an ant" do
    {:ok, world} = %World{nests: %{1 => %Nest{id: 1}}} |> World.spawn_ant(1)

    assert [%Ant{nest_id: 1}] = Map.values(world.ants)
  end

  test "spawned ants have unique ids" do
    {:ok, world} = World.spawn_ant(%World{nests: %{1 => %Nest{id: 1}}}, 1)
    {:ok, world} = World.spawn_ant(world, 1)

    [ant_1, ant_2] = Map.values(world.ants)

    refute ant_1.id == ant_2.id
  end

  test "spawning errors when nest has no food" do
    nest = %Nest{food: 0}
    {:ok, world} = World.spawn_ant(%World{nests: %{nest.id => nest}}, nest.id)

    assert nest == World.find(world, nest.id)
  end

  test "spawning errors when name doesn't exist" do
    assert {:error, :unknown_nest} = World.spawn_ant(%World{}, 1)
  end

  test "moving an ant" do
    {:ok, world} = %World{ants: %{1 => %Ant{id: 1}}}
    |> World.move_ant(1, {0, 1})

    assert [%Ant{pos: {0, 1}}] = Map.values(world.ants)
  end

  test "moving an ant over food picks up food" do
    world = %World{ants: %{1 => %Ant{id: 1, pos: {0, 0}}}}
    world = World.spawn_food(world, {1, 1}, 1)
    {:ok, world} = World.move_ant(world, 1, {1, 1})

    assert [%Ant{id: 1, pos: {1, 1}, has_food: true}] = Map.values(world.ants)
    assert [] = world |> World.food
  end

  test "moving an ant with food does not pick up food" do
    world = %World{ants: %{1 => %Ant{id: 1, pos: {0, 0}, has_food: true}}}
    world = World.spawn_food(world, {1, 1}, 1)
    {:ok, world} = World.move_ant(world, 1, {1, 1})

    assert [%Ant{id: 1, pos: {1, 1}, has_food: true}] = Map.values(world.ants)
    assert [%Food{pos: {1, 1}, quantity: 1}] = world |> World.food
  end

  test "moving an ant with food over a nest drops food" do
    world = %World{
      ants: %{2 => %Ant{id: 2, nest_id: 1, pos: {0, 1}, has_food: true}},
      nests: %{1 => %Nest{id: 1, food: 0}}
    }

    {:ok, world} = World.move_ant(world, 2, {0, -1})

    assert [%Ant{has_food: false}] = Map.values(world.ants)
    assert [%Nest{food: 1}] = Map.values(world.nests)
  end

  test "moving errors when ant does not exist" do
    assert {:error, :unknown_ant} = %World{} |> World.move_ant(1, {0, 1})
  end

  test "spawning food" do
    food = %World{} |> World.spawn_food({2, 3}) |> World.food
    assert [%Food{pos: {2, 3}, quantity: 1}] = food
  end

  test "spawning multiple food" do
    food = %World{} |> World.spawn_food({2, 3}, 3) |> World.food
    assert [%Food{pos: {2, 3}, quantity: 3}] = food
  end

  test "picking up food" do
    food = %World{}
    |> World.spawn_food({2, 3}, 3)
    |> World.pick_up_food({2, 3})
    |> World.food

    assert [%Food{pos: {2, 3}, quantity: 2}] = food
  end

  test "finding an ant" do
    ant_1 = %Ant{id: 1}
    ant_2 = %Ant{id: 2}
    world = %World{ants: %{1 => ant_1, 2 => ant_2}}

    assert World.ant(world, 1) == ant_1
  end

  test "finding a nest" do
    nest_1 = %Nest{id: 1, team: "me"}
    nest_2 = %Nest{id: 2, team: "you"}
    world = %World{nests: %{1 => nest_1, 2 => nest_2}}

    assert World.nest(world, "me") == nest_1
  end

  test "finding by id" do
    nest = %Nest{id: 1}
    ant = %Ant{id: 2}
    world = %World{ants: %{2 => ant}, nests: %{1 => nest}}

    assert World.find(world, 1) == nest
    assert World.find(world, 2) == ant
  end

  test "get surroundings" do
    nest = %Nest{id: 1, pos: {0, 0}}
    ant = %Ant{id: 2, pos: {1, 0}}
    world = %World{ants: %{2 => ant}, nests: %{1 => nest}}

    {:ok, %{e: found}} = World.surroundings(world, 1)

    assert found == [ant]
  end

  test "get surroundings can fail" do
    assert World.surroundings(%World{}, 1) == {:error, :id_not_found}
  end
end
