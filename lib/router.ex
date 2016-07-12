defmodule Router do
  use Plug.Router

  @commands """
  Commands:
    /join/:name                 Join the arena. Your (team) name must be unique.
    /:nest-id/spawn             Spawns an ant. Requires 1 food.
    /:nest-id/leave             Leaves the game
    /:ant-id/look               Look around.
    /:ant-id/move/:direction    Move either n, ne, e, se, s, sw, w, nw
    /id:/stat                   Immediately return the status of the object with the :id
  """

  plug Plug.Static,
    at: "/elm",
    from: "/elm"

  plug Plug.Logger
  plug :match
  plug :dispatch

  get "/" do
    send_resp(conn, 200, "Welcome to Ant Battles! \n\n#{@commands}")
  end

  get "/join/:team" do
    team
    |> Engine.join
    |> build_response
    |> respond(conn)
  end

  get "/:nest_id/spawn" do
    {converted_id, _} = Integer.parse(nest_id)

    converted_id
    |> Engine.spawn_ant
    |> build_response
    |> respond(conn)
  end

  get "/:ant_id/look" do
    {converted_id, _} = Integer.parse(ant_id)

    converted_id
    |> Engine.look
    |> build_response
    |> respond(conn)
  end

  get "/:ant_id/move/:direction" do
    {converted_id, _} = Integer.parse(ant_id)

    converted_id
    |> Engine.move_ant(direction)
    |> build_response
    |> respond(conn)
  end

  get "/:id/info" do
    {converted_id, _} = Integer.parse(id)

    converted_id
    |> Engine.info
    |> build_response
    |> respond(conn)
  end

  get "/:nest_id/leave" do
    {converted_id, _} = Integer.parse(nest_id)

    converted_id
    |> Engine.leave
    |> build_response
    |> respond(conn)
  end

  match _ do
    send_resp(conn, 404, "Woops!")
  end

  defp respond({:ok, response}, conn), do: send_resp(conn, 200, response)
  defp respond({:error, _}, conn), do: send_resp(conn, 500, "Unable to encode response!")

  defp build_response({status, msg}), do: Poison.encode(%{status: status, message: msg})
end
