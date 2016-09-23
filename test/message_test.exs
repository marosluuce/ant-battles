defmodule MessageTest do
  use ExUnit.Case, async: true

  alias AntBattles.Ant
  alias AntBattles.Food
  alias AntBattles.Message
  alias AntBattles.Nest
  alias AntBattles.World

  test "nest details" do
    nest = %Nest{id: 1, team: "me", pos: {0, 0}, food: 5}

    assert %{
      type: :nest,
      location: [0, 0],
      id: 1,
      team: "me",
      food: 5,
      ants: 0
    } == Message.details(nest)
  end

  test "ant details" do
    ant = %Ant{pos: {0, 0}, id: 1, nest_id: 2, team: "me", has_food: false}

    assert %{
      type: :ant,
      location: [0, 0],
      id: 1,
      nest: 2,
      team: "me",
      got_food: false
    } == Message.details(ant)
  end

  test "food details" do
    assert %{
      type: :food,
      location: [0, 0],
      quantity: 2
    } == Message.details(%Food{pos: {0, 0}, quantity: 2})
  end

  test "ant details with surroundings" do
    ant_1 = %Ant{pos: {0, 0}, id: 1, nest_id: 2, team: "me", has_food: false}
    ant_2 = %Ant{pos: {1, 1}, id: 2, nest_id: 2, team: "me", has_food: false}
    world = %World{ants: [ant_1, ant_2], food: %{{0, 1} => 1}}

    assert %{
      type: :ant,
      location: [0, 0],
      id: 1,
      nest: 2,
      team: "me",
      got_food: false,
      surroundings: %{
        n: [Message.details(%Food{pos: {0, 1}, quantity: 1})],
        s: [],
        e: [],
        w: [],
        ne: [Message.details(ant_2)],
        nw: [],
        se: [],
        sw: []
      }
    } == Message.with_surroundings(ant_1, world)
  end
end
