defmodule Garph do
  defmacro __using__(opts) do
    quote do
      def eval(graph, func_name, params) do
        case apply __MODULE__, func_name, params do
          {:result, value} -> value
          {outcome, params} -> eval graph, graph[func_name][outcome], params
        end
      end
    
      def evaluate(graph, params) do
        [{entry_point, _} | _] = graph
        eval graph, entry_point, params
      end

      def to_dot(graph) do
        {entry_point, _} = hd(graph) 
        head = ["digraph G {"]
        subgraphs = Enum.map(graph, &build_subgraph/1)
        node_style = ["  node [shape = rect];"]
        connections = connections(graph)
        start = ["  start -> node_#{entry_point}_label"]
        close = ["  start [style = filled, color = \"#BDECB6\"];", "}"]
        Enum.join(head ++ subgraphs ++ node_style ++ connections ++ start ++ close, "\n") 
      end

      defp connections(graph) do
        Enum.reduce(graph, [], fn({method, out_edges}, conns) ->
          conns ++ Enum.map(out_edges, fn({edge, dest}) -> 
            if is_atom(dest) do
              "  node_#{method}_#{edge} -> node_#{dest}_label"
            else
              end_node = "node_#{method}_#{edge}_end"
              ~s(  node_#{method}_#{edge} -> #{end_node}; #{end_node} [label = "#{dest}"];)
            end
          end) 
        end)
      end

      defp build_subgraph({method, out_edges}) do
        head = [
                 "  subgraph cluster_#{method}{",
                 "    style = filled;",
                 "    color = lightgrey;",
                 "    node [style = filled, color = white, shape = rect];"
               ]
        nodes = Enum.map(out_edges, fn({edge, _dest}) ->
          "    node_#{method}_#{edge} [label = #{edge}];"
        end)
        method_label = ["    node_#{method}_label [label = #{method}, color = \"#FFB347\"]"]
        close = ["  }"] 
        Enum.join(head ++ nodes ++ method_label ++ close, "\n")
      end
    end
  end
end
