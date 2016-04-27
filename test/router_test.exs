defmodule RouterTest do
  use ExUnit.Case
  use Plug.Test

  @opts Router.init([])

  setup do
    Engine.start_link(1)
    :ok
  end

  test "renders /" do
    conn = conn(:get, "/")
    |> Router.call(@opts)

    assert conn.status == 200
    assert conn.resp_body == "Welcome to Ant Battles!"
  end

  test "joining" do
    conn = conn(:get, "/join/me")
    |> Router.call(@opts)

    assert conn.status == 200
    {:ok, response} = Poison.decode(conn.resp_body)
    assert %{"status" => "ok", "message" => %{}} = response
  end

  test "spawning an ant" do
    conn = conn(:get, "/join/me")
    |> Router.call(@opts)

    {:ok, %{"message" => %{"id" => id}}} = Poison.decode(conn.resp_body)

    conn = conn(:get, "/#{id}/spawn")
    |> Router.call(@opts)

    assert conn.status == 200
    {:ok, response} = Poison.decode(conn.resp_body)
    assert %{"status" => "ok", "message" => %{}} = response
  end

  test "moving an ant" do
    conn = conn(:get, "/join/me")
    |> Router.call(@opts)

    {:ok, %{"message" => %{"id" => nest_id}}} = Poison.decode(conn.resp_body)

    conn = conn(:get, "/#{nest_id}/spawn")
    |> Router.call(@opts)

    {:ok, %{"message" => %{"id" => ant_id}}} = Poison.decode(conn.resp_body)

    conn = conn(:get, "/#{ant_id}/move/n")
    |> Router.call(@opts)

    assert conn.status == 200
    {:ok, response} = Poison.decode(conn.resp_body)
    assert %{"status" => "ok", "message" => %{}} = response
  end

  test "looking with an ant" do
    conn = conn(:get, "/join/me")
    |> Router.call(@opts)

    {:ok, %{"message" => %{"id" => nest_id}}} = Poison.decode(conn.resp_body)

    conn = conn(:get, "/#{nest_id}/spawn")
    |> Router.call(@opts)

    {:ok, %{"message" => %{"id" => ant_id}}} = Poison.decode(conn.resp_body)

    conn = conn(:get, "/#{ant_id}/look")
    |> Router.call(@opts)

    assert conn.status == 200
    {:ok, response} = Poison.decode(conn.resp_body)
    assert %{"status" => "ok", "message" => %{}} = response
  end

  test "getting info for an entity" do
    conn = conn(:get, "/join/me")
    |> Router.call(@opts)

    {:ok, %{"message" => %{"id" => nest_id}}} = Poison.decode(conn.resp_body)

    conn = conn(:get, "/#{nest_id}/info")
    |> Router.call(@opts)

    assert conn.status == 200
    {:ok, response} = Poison.decode(conn.resp_body)
    assert %{"status" => "ok", "message" => %{}} = response
  end
end
