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
    end
  end
end
