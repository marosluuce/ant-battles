defmodule Join do
  defstruct team: ""
end

defimpl Command, for: Join do
  def id(%Join{team: team}), do: team

  def execute(%Join{team: team}, world), do: World.register(world, team)

  def success(%Join{team: team}, pid, world) do
    nest = world |> World.nest(team)

    send pid, {:ok, Message.details(nest)}
  end

  def failure(_, pid, _), do: send pid, {:error, :name_taken}
end
