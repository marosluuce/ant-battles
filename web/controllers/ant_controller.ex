defmodule AntBattles.AntController do
  use AntBattles.Web, :controller

  alias AntBattles.Engine
  alias AntBattles.Move

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
    {status, message} = Engine.spawn_ant(nest_id)

    json(conn, %{status: status, message: message})
  end

  def move(conn, %{"ant_id" => ant_id, "direction" => direction}) do
    {status, message} = Engine.move_ant(ant_id, Move.convert_dir(direction))

    json(conn, %{status: status, message: message})
  end

  def look(conn, %{"ant_id" => ant_id}) do
    {status, message} = Engine.look(ant_id)

    json(conn, %{status: status, message: message})
  end

  def info(conn, %{"id" => id}) do
    {status, message} = Engine.info(id)

    json(conn, %{status: status, message: message})
  end
end
