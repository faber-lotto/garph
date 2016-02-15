defmodule Testmod do
  use Garph

  @play_tennis [
                 outlook:
                   [
                     rainy: :wind,
                     overcast: nil,
                     sunny: :humidity
                   ],
                 humidity:
                   [
                     normal: nil,
                     high: :temperature
                   ],
                 wind:
                   [
                     strong: nil,
                     weak: nil
                   ],
                 temperature:
                   [
                     low: nil,
                     high: nil
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
