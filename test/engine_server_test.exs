defmodule EngineServerTest do
  use ExUnit.Case, async: true

  test "a new server is an empty world" do
    {:ok, state} = EngineServer.init(%Engine{})

    assert state == %Engine{}
  end

  test "gets current world" do
    engine = %Engine{}

    assert {:reply, %World{}, engine} ==
      EngineServer.handle_call(:get_world, {self(), :ref}, engine)
  end

  test "known commands succeed" do
    engine = %Engine{}
    assert {:reply, {:ok, :ok}, _} = EngineServer.handle_call({:run, %Noop{}}, {}, engine)
  end

  test "unknown commands error" do
    assert {:reply, {:error, :unknown_command}, _} = EngineServer.handle_call({:run, :unknown}, {}, %Engine{})
  end
end
