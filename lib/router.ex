defmodule Router do
  use Plug.Router

  plug :match
  plug :dispatch

  get "/" do
    send_resp(conn, 200, "Welcome to Ant Battles!")
  end

  get "/join/:team" do
    conn.remote_ip
    |> Engine.join(team)
    |> build_response
    |> respond(conn)
  end

  get "/:nest_id/spawn" do
    {converted_id, _} = Integer.parse(nest_id)

    conn.remote_ip
    |> Engine.spawn_ant(converted_id)
    |> build_response
    |> respond(conn)
  end

  get "/:ant_id/look" do
    {converted_id, _} = Integer.parse(ant_id)

    conn.remote_ip
    |> Engine.look(converted_id)
    |> build_response
    |> respond(conn)
  end

  get "/:ant_id/move/:direction" do
    {converted_id, _} = Integer.parse(ant_id)

    conn.remote_ip
    |> Engine.move_ant(converted_id, direction)
    |> build_response
    |> respond(conn)
  end

  get "/:id/info" do
    {converted_id, _} = Integer.parse(id)

    conn.remote_ip
    |> Engine.info(converted_id)
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
