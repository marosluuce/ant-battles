defmodule AntTest do
  use ExUnit.Case

  test "can move an ant" do
    ant = %Ant{pos: {0, 0}} |> Ant.move({1, 0})
    assert ant.pos == {1, 0}
  end

  test "can pick up food" do
    ant = %Ant{has_food: false} |> Ant.pick_up_food
    assert ant.has_food
  end

  test "can drop food" do
    ant = %Ant{has_food: true} |> Ant.drop_food
    refute ant.has_food
  end
end
