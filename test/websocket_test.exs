defmodule WebsocketTest do
  use ExUnit.Case

  setup do
    Engine.start_link(1)
    :ok
  end

  test "sends the observed world" do
    {:reply, {:text, json}, _, _} = Websocket.websocket_info(:observe, :req, :state)

    assert %{"ants" => [], "food" => [], "nests" => []} = Poison.decode!(json)
  end

  test "observing loops" do
    Websocket.websocket_info(:observe, :req, :state)

    assert_received :observe
  end
end
