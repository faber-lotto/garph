defmodule GarphTest do
  use ExUnit.Case
  doctest Garph

  test "evaluates the graph correctly" do
    assert Testmod.play_tennis?(1, 0.7, 3, 20) == true
    assert Testmod.play_tennis?(1, 0.7, 9, 30) == false
    assert Testmod.play_tennis?(1, 0.5, 9, 20) == true
    assert Testmod.play_tennis?(0.5, 0.7, 3, 30) == true
    assert Testmod.play_tennis?(0, 0.7, 3, 30) == true
    assert Testmod.play_tennis?(0, 0.5, 7, 30) == false
  end
end
