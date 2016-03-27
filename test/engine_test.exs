defmodule EngineTest do
  use ExUnit.Case

  setup do
    Engine.start_link
    :ok
  end

  test "registers a user" do
    assert {:ok, _} = Engine.register(:me, "name")
  end
end
