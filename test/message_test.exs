defmodule MessageTest do
  use ExUnit.Case, async: true

  test "nest details" do
    nest = %Nest{id: 1, team: "me", pos: {0, 0}, food: 5}

    assert Message.details(nest, %World{nests: [nest], ants: []}) == %{
      type: :nest,
      location: {0, 0},
      id: 1,
      team: "me",
      food: 5,
      ants: 0
    }
  end

  test "ant details" do
    ant = %Ant{pos: {0, 0}, id: 1, nest_id: 2, team: "me", has_food: false}

    assert Message.details(ant, %World{ants: [ant]}) == %{
      type: :ant,
      location: {0, 0},
      id: 1,
      nest: 2,
      surroundings: %{},
      team: "me",
      got_food: false
    }
  end
end
