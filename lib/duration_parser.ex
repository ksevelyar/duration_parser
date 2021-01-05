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

  iex> DurationParser.parse_minutes("a24.5")
  {:error, "expected 2 digits"}
  """
end
