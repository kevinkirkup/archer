defmodule ArcherTest do
  use ExUnit.Case
  doctest Archer

  test "greets the world" do
    assert Archer.hello() == :world
  end
end
