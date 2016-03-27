defmodule Commands do

  def move(user, ant_id, :n), do: {user, %Move{ant_id: ant_id, direction: {0, 1}}}
  def move(user, ant_id, :s), do: {user, %Move{ant_id: ant_id, direction: {0, -1}}}
  def move(user, ant_id, :e), do: {user, %Move{ant_id: ant_id, direction: {1, 0}}}
  def move(user, ant_id, :w), do: {user, %Move{ant_id: ant_id, direction: {-1, 0}}}
  def move(user, ant_id, :nw), do: {user, %Move{ant_id: ant_id, direction: {-1, 1}}}
  def move(user, ant_id, :ne), do: {user, %Move{ant_id: ant_id, direction: {1, 1}}}
  def move(user, ant_id, :sw), do: {user, %Move{ant_id: ant_id, direction: {-1, -1}}}
  def move(user, ant_id, :se), do: {user, %Move{ant_id: ant_id, direction: {1, -1}}}
  def move(user, ant_id, _), do: {user, %Move{ant_id: ant_id, direction: {0, 0}}}
end
