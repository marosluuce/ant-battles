defmodule AntBattles.Websocket do
  alias AntBattles.Engine
  @behaviour :cowboy_websocket_handler
  @timeout 60000

  def init(_, _, _), do: {:upgrade, :protocol, :cowboy_websocket}

  def websocket_init(_, req, _) do
    send self(), :observe
    {:ok, req, nil, @timeout}
  end

  def websocket_handle(_, req, state), do: {:ok, req, state}

  def websocket_info(:observe, req, state) do
    send self(), :observe

    {_, message} = Engine.observe

    {:reply, {:text, Poison.encode!(message)}, req, state}
  end

  def websocket_info(_, req, state), do: {:ok, req, state}

  def websocket_terminate(_, _, _), do: :ok
end
