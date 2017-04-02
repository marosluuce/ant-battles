# defmodule WorldTest do
#   use ExUnit.Case, async: true

#   alias AntBattles.Ant
#   alias AntBattles.AntStore
#   alias AntBattles.Food
#   alias AntBattles.FoodStore
#   alias AntBattles.Nest
#   alias AntBattles.NestStore
#   alias AntBattles.World

#   setup do
#     [world: AntBattles.WorldHelper.create()]
#   end

#   test "can create a new world" do
#     assert %World{} = World.new("name")
#   end

#   test "a new world has food", context do
#     world = context[:world]
#     FoodStore.add_food(world.food, {0, 0}, 10)
#     assert [%Food{quantity: 10}] = FoodStore.all(world.food)
#   end

#   test "registering creates a nest", context do
#     :ok = World.register(context[:world], "name")
#     assert [%Nest{team: "name"}] = NestStore.all(context[:world].nests)
#   end

#   test "registering does not create duplicate", context do
#     :ok = World.register(context[:world], "name")
#     assert {:error, :name_taken} = World.register(context[:world], "name")
#   end

#   test "finding by id", context do
#     world = context[:world]
#     nest = %Nest{id: 1}
#     ant = %Ant{id: 2}

#     NestStore.register(world.nests, nest)
#     AntStore.add(world.ants, ant)

#     assert %Nest{id: 1} = World.find(world, 1)
#     assert %Ant{id: 2} = World.find(world, 2)
#   end

#   test "get surroundings", context do
#     world = context[:world]
#     nest = %Nest{id: 1, pos: {0, 0}}
#     ant = %Ant{id: 2, pos: {1, 0}}
#     AntStore.add(world.ants, ant)
#     NestStore.register(world.nests, nest)

#     {:ok, %{e: found}} = World.surroundings(world, 1)

#     assert found == [ant]
#   end

#   test "get surroundings can fail", context do
#     assert {:error, :id_not_found} = World.surroundings(context[:world], 1)
#   end
# end
