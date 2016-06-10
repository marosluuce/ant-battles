defmodule NestTest do
  use ExUnit.Case, async: true

  test "spawning an ant decreases food" do
    assert %Nest{food: 4} = Nest.spawn_ant(%Nest{food: 5})
  end

  test "spawning an ant increases ant count" do
    assert %Nest{ants: 1} = Nest.spawn_ant(%Nest{food: 5})
  end

  test "spawning an ant can fail" do
    assert {:error, :insufficient_food} = Nest.spawn_ant(%Nest{food: 0})
  end

  test "delivering food increases food" do
    assert %Nest{food: 1} = Nest.deliver_food(%Nest{food: 0})
  end
end
