defprotocol Command do
  @fallback_to_any true

  def execute(command, world)
  def success(command, pid, world)
  def failure(command, pid, world)
end

defimpl Command, for: Any do
  def execute(_, world), do: world

  def success(_, pid, _), do: send pid, {:error, :unknown_command}

  def failure(_, pid, _), do: send pid, {:error, :unknown_command}
end
