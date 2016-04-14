## ![image](https://cdn.rawgit.com/faber-lotto/garph/master/logo.svg)  Garph

_Graphical algorithm result processing helper_

Garph is a simple way to implement complex decision trees by using graphs. It can be used with plain elixir or beneath a phoenix project.

### Features

* Easy to use rule engine witten in plain elixir
* Simplifies decision trees by breaking them down into single function calls.
* Easy documentation of complex decision graphs through DOT file export.

### Installation

Add garph [hex package](https://hex.pm/packages/garph) to your list of dependencies in `mix.exs`:

```
def deps do
  [{:garph, "~> 0.0.1"}]
end
```

Alternatively you can also require it directiy from github, of course:

```
def deps do
  [{:garph, git: "https://github.com/faber-lotto/garph"}]
end
```

### Usage

Garph can be enabled by importing the Garph module:

```
defmodule YourModule do
  import  Garph
  ...
end
```

#### Defining graph structure

First we need to describe the graph itself, that should be used by garph to call functions. We can achieve this by creating a nested keyword list with 2 levels as a module variable.

```
defmodule Sports do
  import  Garph

  @play_tennis [
                 outlook:
                   [
                     rainy: :wind,
                     overcast: "yes",
                     sunny: :humidity
                   ],
                 humidity:
                   [
                     normal: "yes",
                     high: :temperature
                   ],
                 wind:
                   [
                     strong: "no",
                     weak: "yes"
                   ],
                 temperature:
                   [
                     low: "yes",
                     high: "no"
                   ]
               ]
```
This will result in the following graph:

![image](https://cdn.rawgit.com/faber-lotto/garph/master/play_tennis.svg)

Please note, that there are two kinds of keys here. The keys on the first level represent the name of the functions wich may be called according to the graphs instructions. The first key is identical to the first function called, when walking the garph. In this case this would be the function _outlook()_.

The second level keys represent the possible results of a certain function. If the value for that key is an atom _eg. :rainy_ and matches the result tuple coming from _outlook()_ , _eg. {:rainy, attributes}_, another function named _wind(*attributes)_ will be called. If the value is a string no further functions will be called and it will be just used as an informational tag, when the graph is plotted.

#### Defining functions

As mentioned before the first level keys of _@play_tennis_ represent the minimum set of functions we need to define in order to get the graph up and running.

```
def outlook(outlook, humidity, wind, temperature) do
  cond do
    outlook >= 0 && outlook <= 0.25 -> {:rainy, [wind]}
    outlook > 0.25 && outlook <= 0.75 -> {:result, true}
    outlook > 0.75 && outlook <= 1 -> {:sunny, [humidity, temperature]}
  end
end

```

#### Results and attributes

A function used by garph always needs to return a result tuple, wich allows garph to evaulate if it has reached the end of the graph, or if another function has to be called. The reult tuple also contains a list of parameters that will be when doing the latter.

```
...
outlook > 0.25 && outlook <= 0.75 -> {:result, true}
outlook > 0.75 && outlook <= 1 -> {:sunny, [humidity, temperature]}
...
```

In the example above the result _:sunny_ combined with the graph instructions from @play_tennis leads to calling _humidity(humidity, temperature)_.

Please note, that _:result_ is a reserved key for garph result tuples. Using it will cause garph to assume that the end of the graph has been reached and return the given payload. In this case _true_.

#### Putting it all together

```
defmodule Sports do
  use Garph

  @play_tennis [
                 outlook:
                   [
                     rainy: :wind,
                     overcast: "yes",
                     sunny: :humidity
                   ],
                 humidity:
                   [
                     normal: "yes",
                     high: :temperature
                   ],
                 wind:
                   [
                     strong: "no",
                     weak: "yes"
                   ],
                 temperature:
                   [
                     low: "yes",
                     high: "no"
                   ]
               ]

  def play_tennis?(outlook, humidity, wind, temperature) do
    evaluate @play_tennis, [outlook, humidity, wind, temperature]
  end

  def export_dot do
    {:ok, file} = File.open "play_tennis.dot", [:write]
    IO.binwrite file, Testmod.to_dot(@play_tennis)
  end

  def outlook(outlook, humidity, wind, temperature) do
    cond do
      outlook >= 0 && outlook <= 0.25 -> {:rainy, [wind]}
      outlook > 0.25 && outlook <= 0.75 -> {:result, true}
      outlook > 0.75 && outlook <= 1 -> {:sunny, [humidity, temperature]}
    end
  end

  def humidity(humidity, temperature) do
    cond do
      humidity >= 0 && humidity <= 0.6 -> {:result, true}
      humidity > 0.6 && humidity <= 1 -> {:high, [temperature]}
    end
  end

  def wind(value) do
    cond do
      value >= 0 && value < 7 -> {:result, true}
      value >= 7 -> {:result, false}
    end
  end

  def temperature(value) do
    cond do
      value <= 22 -> {:result, true}
      value > 22 -> {:result, false}
    end
  end
end

```

In this example all necessary functions have been implemented. What we need now, is a starting point for walking our graph.
To achieve this you should use garphs _evaluate(graph, attributes)_ function wich takes the actual graph and attributes used to call its first node. You should encapsulate it to make it easily accessible from outside the module:

```
def play_tennis?(outlook, humidity, wind, temperature) do
  evaluate @play_tennis, [outlook, humidity, wind, temperature]
end
```

Now we are able to ask the graph if we should play tennis just by calling

```
Sports.play_tennis?(outlook, humidity, wind, temperature)
```

### Documentation / Plotting

Sometimes, you may want to plot the graph, eg. for documentational purposes. To achieve this you may just implement a function that exports the graphs data to the dot format:

```
def export_dot do
  {:ok, file} = File.open "play_tennis.dot", [:write]
  IO.binwrite file, Sports.to_dot(@play_tennis)
end
```

Running

```
Sports.export_dot()
```

will result in a file play_tennis.dot which can be used with [graphviz]() to plot it through the console command:

```
dot -Tpng play_tennis.dot > play_tennis.png
```

#### Credits

Special thanks to:

* Farhad Taebi

### Copyright and License

Copyright (c) 2016, Faber Lotto GmbH.

Garph source code is licensed under the [MIT License](https://github.com/faber-lotto/garph/blob/master/LICENSE.md).
