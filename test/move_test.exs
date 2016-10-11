defmodule AntBattles.MoveTest do
  use ExUnit.Case, async: true

  alias AntBattles.Move

  test 'converts a known direction' do
    assert Move.from_dir(:n) == {0, 1}
  end

  test 'uses a default when converting an unknown direction' do
    assert Move.from_dir(:unknown) == {0, 0}
  end

  test 'converts a point to a direction' do
    assert Move.to_dir({-1, -1}) == {:ok, :sw}
  end

  test 'errors converting an unknown point' do
    assert Move.to_dir({-5, 10}) == {:error, :invalid_direction}
  end

  test 'converts a string direction into an atom' do
    assert Move.convert_dir("n") == :n
  end

  test 'it fails to convert an unknown string direction' do
    assert Move.convert_dir("unknown") == {:error, :unknown_direction}
  end
end
