defmodule AntBattles.AntControllerTest do
  use AntBattles.ConnCase
  alias AntBattles.Engine

  setup do
    Engine.reset()
    :ok
  end

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Welcome to Ant Battles!"
  end

  test "joining", %{conn: conn} do
    conn = get conn, "/api/join/me"

    assert %{"status" => "ok", "message" => %{}} = json_response(conn, 200)
  end

  test "spawning an ant", %{conn: conn} do
    conn = get conn, "/api/join/me"
    %{"message" => %{"id" => id}} = json_response(conn, 200)

    conn = get conn, "/api/#{id}/spawn"

    assert %{"status" => "ok", "message" => %{}} = json_response(conn, 200)
  end

  test "moving an ant", %{conn: conn} do
    conn = get conn, "/api/join/me"
    %{"message" => %{"id" => id}} = json_response(conn, 200)

    conn = get conn, "/api/#{id}/spawn"
    %{"message" => %{"id" => ant_id}} = json_response(conn, 200)

    conn = get conn, "/api/#{ant_id}/move/n"

    assert %{"status" => "ok", "message" => %{}} = json_response(conn, 200)
  end

  test "looking with an ant", %{conn: conn} do
    conn = get conn, "/api/join/me"
    %{"message" => %{"id" => id}} = json_response(conn, 200)

    conn = get conn, "/api/#{id}/spawn"
    %{"message" => %{"id" => ant_id}} = json_response(conn, 200)

    conn = get conn, "/api/#{ant_id}/look"

    assert %{"status" => "ok", "message" => %{}} = json_response(conn, 200)
  end

  test "getting info for an entity", %{conn: conn} do
    conn = get conn, "/api/join/me"
    %{"message" => %{"id" => id}} = json_response(conn, 200)

    conn = get conn, "api/#{id}/info"

    assert %{"status" => "ok", "message" => %{}} = json_response(conn, 200)
  end
end
