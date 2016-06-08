defmodule EngineServerTest do
  use ExUnit.Case, async: true

  test "a new server is an empty world" do
    {:ok, state} = EngineServer.init(1)

    assert state == %Engine{delay: 1}
  end

  test "enqueues a command" do
    command = %Noop{}

    {:reply, reply, state} =
      EngineServer.handle_call({:enqueue, command}, {self(), :ref}, %Engine{})

    assert reply == {:ok, :enqueued}
    assert state.instructions == [{self(), command}]
  end

  test "enqueues unique commands" do
    command_1 = %Noop{id: 1}
    command_2 = %Noop{id: 2}

    engine = %Engine{instructions: [{self(), command_1}]}

    {:reply, reply, state} =
      EngineServer.handle_call({:enqueue, command_2}, {self(), :ref}, engine)

    assert reply == {:ok, :enqueued}
    assert state.instructions == [{self(), command_1}, {self(), command_2}]
  end

  test "does not enqueue duplicate commands" do
    command = %Noop{id: 1}
    engine = %Engine{instructions: [{self(), command}]}

    {:reply, error, state} =
      EngineServer.handle_call({:enqueue, command}, {self(), :ref}, engine)

    assert error == {:error, :already_enqueued}
    assert state.instructions == [{self(), command}]
  end

  test "gets current world" do
    engine = %Engine{}

    assert {:reply, %World{}, engine} ==
      EngineServer.handle_call(:get_world, {self(), :ref}, engine)
  end

  test "tick clears the command queue" do
    engine = %Engine{instructions: [{self(), %Noop{}}]}
    {:noreply, state} =
      EngineServer.handle_cast(:tick, engine)

    assert Enum.empty?(state.instructions)
  end

  test "known commands succeed" do
    engine = %Engine{instructions: [{self(), %Noop{}}]}
    EngineServer.handle_cast(:tick, engine)

    assert_received {:ok, :ok}
  end

  test "unknown commands error" do
    EngineServer.handle_cast(:tick, %Engine{instructions: [{self(), :unknown}]})

    assert_received {:error, :unknown_command}
  end

  test "tick executes queued commands" do
    initial_world = %World{}
    instruction = {self(), %Join{team: "name"}}
    engine = %Engine{world: initial_world, instructions: [instruction]}

    {:noreply, %Engine{world: updated_world}} = EngineServer.handle_cast(:tick, engine)

    refute initial_world == updated_world
  end
end
