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

  test "exports graph representation in dot format" do
    assert Testmod.to_dot([a: [a1: :b], b: [b1: "description"]]) == "digraph G {\n  subgraph cluster_a{\n    style = filled;\n    color = lightgrey;\n    node [style = filled, color = white, shape = rect];\n    node_a_a1 [label = a1];\n    node_a_label [label = a, color = \"#FFB347\"]\n  }\n  subgraph cluster_b{\n    style = filled;\n    color = lightgrey;\n    node [style = filled, color = white, shape = rect];\n    node_b_b1 [label = b1];\n    node_b_label [label = b, color = \"#FFB347\"]\n  }\n  node [shape = rect];\n  node_a_a1 -> node_b_label\n  node_b_b1 -> node_b_b1_end; node_b_b1_end [label = \"description\"];\n  start -> node_a_label\n  start [style = filled, color = \"#BDECB6\"];\n}"
  end
end
