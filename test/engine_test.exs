defmodule EngineTest do
  use ExUnit.Case

  setup do
    Engine.start_link
    :ok
  end

  test "registers a user" do
    assert {:ok, _} = Engine.register(:me, "name")
  end

  @tag :skip
  test "spawns an ant" do
    {:ok, %{id: nest_id}} = Engine.register(:me, "name")
    assert {:ok, _} = Engine.spawn(:me, nest_id)
  end
end
