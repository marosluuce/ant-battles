defprotocol Command do
  @fallback_to_any true

  def execute(command, world)
  def notify(command, pid, world)
end

defimpl Command, for: Any do
  def execute(_, world), do: world

  def notify(_, pid, _), do: send pid, {:error, :unknown_command}
end
