defmodule NestTest do
  use ExUnit.Case

  test "consuming food decreases food" do
    {:ok, nest} = %Nest{food: 5} |> Nest.consume_food
    assert nest.food == 4
  end

  test "cannot consume more food than available" do
    {:error, message} = %Nest{food: 0, name: "name"} |> Nest.consume_food
    assert message == "Nest name has insufficent food."
  end

  test "delivering food increases food" do
    nest = %Nest{food: 0} |> Nest.deliver_food
    assert nest.food == 1
  end
end
