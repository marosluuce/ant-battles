defmodule Location do
  def random(radius) do
    x = :rand.uniform(radius) - 25
    y = :rand.uniform(radius) - 25

    case {x, y} do
      {0, 0} -> Location.random(radius)
      coordinate -> coordinate
    end
  end
end
