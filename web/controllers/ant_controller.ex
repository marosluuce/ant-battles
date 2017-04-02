defmodule AntBattles.AntController do
  use AntBattles.Web, :controller

  alias AntBattles.Engine
  alias AntBattles.Move

  @engine Application.get_env(:ant_battles, :engine)

  def index(conn, _params) do
    render conn, "index.html"
  end

  def admin(conn, _params) do
    render conn, "admin.html"
  end

  def join(conn, %{"team" => team}) do
    {status, message} = Engine.join(@engine, team)

    json(conn, %{status: status, message: message})
  end

  def spawn(conn, %{"nest_id" => nest_id}) do
    {status, message} = Engine.spawn_ant(@engine, nest_id)

    json(conn, %{status: status, message: message})
  end

  def move(conn, %{"ant_id" => ant_id, "direction" => direction}) do
    {status, message} = Engine.move_ant(@engine, ant_id, Move.convert_dir(direction))

    json(conn, %{status: status, message: message})
  end

  def look(conn, %{"ant_id" => ant_id}) do
    {status, message} = Engine.look(@engine, ant_id)

    json(conn, %{status: status, message: message})
  end

  def info(conn, %{"id" => id}) do
    {status, message} = Engine.info(@engine, id)

    json(conn, %{status: status, message: message})
  end
end
