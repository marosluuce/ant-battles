defmodule Join do
  defstruct team: ""
end

defimpl Command, for: Join do
  def execute(%Join{team: team}, world), do: World.register(world, team)

  def success(%Join{team: team}, pid, world) do
    nest = world |> World.nest(team)

    send pid, {:ok, Message.details(nest, world)}
  end

  def failure(_, pid, _), do: send pid, {:error, :name_taken}
end
