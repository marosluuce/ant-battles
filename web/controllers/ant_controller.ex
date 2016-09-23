defmodule AntBattles.AntController do
  use AntBattles.Web, :controller

  alias AntBattles.Engine

  def index(conn, _params) do
    render conn, "index.html"
  end

  def admin(conn, _params) do
    render conn, "admin.html"
  end

  def join(conn, %{"team" => team}) do
    {status, message} = Engine.join(team)

    json(conn, %{status: status, message: message})
  end

  def spawn(conn, %{"nest_id" => nest_id}) do
    {converted_id, _} = Integer.parse(nest_id)
    {status, message} = Engine.spawn_ant(converted_id)

    json(conn, %{status: status, message: message})
  end

  def move(conn, %{"ant_id" => ant_id, "direction" => direction}) do
    {converted_id, _} = Integer.parse(ant_id)
    {status, message} = Engine.move_ant(converted_id, direction)

    json(conn, %{status: status, message: message})
  end

  def look(conn, %{"ant_id" => ant_id}) do
    {converted_id, _} = Integer.parse(ant_id)
    {status, message} = Engine.look(converted_id)

    json(conn, %{status: status, message: message})
  end

  def info(conn, %{"id" => id}) do
    {converted_id, _} = Integer.parse(id)
    {status, message} = Engine.info(converted_id)

    json(conn, %{status: status, message: message})
  end
end
