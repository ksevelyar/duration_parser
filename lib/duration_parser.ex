defmodule DurationParser do
  @moduledoc """
  Parse a given string as either a time interval or a fractional number of hours
  and return the equivalent number of hours and minutes.

  ## Examples

  iex> DurationParser.parse_minutes("2:15")
  {:ok, 135}

  iex> DurationParser.parse_minutes("02:15")
  {:ok, 135}

  iex> DurationParser.parse_minutes("2h 35m")
  {:ok, 155}

  iex> DurationParser.parse_minutes("10")
  {:ok, 10}

  iex> DurationParser.parse_minutes("10h")
  {:ok, 600}

  iex> DurationParser.parse_minutes("0.5h")
  {:ok, 30}

  iex> DurationParser.parse_minutes("0.5")
  {:ok, 30}

  iex> DurationParser.parse_minutes("10.0")
  {:ok, 600}

  iex> DurationParser.parse_minutes("7.5")
  {:ok, 450}

  iex> DurationParser.parse_minutes("24.5")
  {:ok, 1470}

  # iex> DurationParser.parse_minutes("a24.5")
  # {:error, "expected 2 digits"}
  """

  # def parse_minutes(<<head::binary-size(1), _tail::binary>>)  do
  #   {:error, "expected 2 digits"}
  # end

  def parse_minutes(string) do
    _parse_minutes(string, string)
  end

  defp _parse_minutes(<<head::binary-size(1), tail::binary>>, string) do
    _parse_minutes(head, tail, string)
  end

  defp _parse_minutes(<<>>, string) do
    {:ok, String.to_integer(string)}
  end

  defp _parse_minutes(":", _tail, string) do
    [hours, minutes] = String.split(string, ":")

    {:ok, String.to_integer(hours) * 60 + String.to_integer(minutes)}
  end

  defp _parse_minutes("m", _tail, string) do
    minutes = string |> String.trim() |> Integer.parse()

    {:ok, minutes}
  end

  defp _parse_minutes(".", _tail, string) do
    {hours, _} = string |> String.trim() |> Float.parse()
    {:ok, Kernel.round(hours * 60)}
  end

  defp _parse_minutes("h", _tail, string) do
    [hours, minutesString] = String.split(string, "h")
    {minutes, _} = _parse_minutes_string(minutesString)

    {:ok, String.to_integer(hours) * 60 + minutes}
  end

  defp _parse_minutes(_, tail, string) do
    _parse_minutes(tail, string)
  end

  defp _parse_minutes_string("") do
    {0, ""}
  end

  defp _parse_minutes_string(string) do
    string |> String.trim() |> Integer.parse()
  end
end
