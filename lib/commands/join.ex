defmodule Join do
  defstruct team: ""
end

defimpl Command, for: Join do
  def execute(%Join{team: team}, world), do: World.register(world, team)

  def success(%Join{team: team}, world) do
    nest = world |> World.nest(team)

    {:ok, Message.details(nest)}
  end

  def failure(_, _), do: {:error, :name_taken}
end
