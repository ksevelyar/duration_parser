defmodule DurationParser do
  @moduledoc """
  Parse a given string as either a time interval or a fractional number of hours
  and return the equivalent number of hours and minutes.

  ## Examples

  iex> DurationParser.parse_minutes("2:15")
  {:ok, 135}

  iex> DurationParser.parse_minutes("02:15")
  {:ok, 135}

  iex> DurationParser.parse_minutes(":15")
  {:error, "expected hours"}

  iex> DurationParser.parse_minutes("2h 35m")
  {:ok, 155}

  iex> DurationParser.parse_minutes("10")
  {:ok, 10}

  iex> DurationParser.parse_minutes("10d")
  {:error, "unknown format"}

  iex> DurationParser.parse_minutes("10h")
  {:ok, 600}

  iex> DurationParser.parse_minutes("30m")
  {:ok, 30}

  iex> DurationParser.parse_minutes("0.5h")
  {:ok, 30}

  iex> DurationParser.parse_minutes("h 30m")
  {:error, "expected hours"}

  iex> DurationParser.parse_minutes("0.5")
  {:ok, 30}

  iex> DurationParser.parse_minutes("10.0")
  {:ok, 600}

  iex> DurationParser.parse_minutes("7.5")
  {:ok, 450}

  iex> DurationParser.parse_minutes("7a.5")
  {:error, "expected 2 digits"}

  iex> DurationParser.parse_minutes("24.5")
  {:ok, 1470}

  iex> DurationParser.parse_minutes("a24.5")
  {:error, "expected 2 digits"}
  """

  def parse_minutes(duration_string) do
    detect_format(duration_string, duration_string)
  end

  defp convert_to_minutes(hours_string) do
    case hours_string |> String.trim() |> Integer.parse() do
      {hours, _} -> {:ok, hours * 60}
      _ -> {:error, "expected hours"}
    end
  end

  defp convert_to_minutes(hours_string, minutes_string) do
    hours = hours_string |> String.trim() |> Integer.parse()
    minutes = minutes_string |> String.trim() |> Integer.parse()

    case {hours, minutes} do
      {{hours, _}, {minutes, _}} -> {:ok, hours * 60 + minutes}
      _ -> {:error, "expected hours and minutes"}
    end
  end

  defp detect_format(<<>>, duration_string) do
    case duration_string |> String.trim() |> Integer.parse() do
      {minutes, ""} -> {:ok, minutes}
      {_minutes, _} -> {:error, "unknown format"}
      _ -> {:error, "expected minutes"}
    end
  end

  defp detect_format(<<head::binary-size(1), tail::binary>>, duration_string) do
    parse_format(head, tail, duration_string)
  end

  defp parse_format(":", _tail, duration_string) do
    case String.split(duration_string, ":") do
      ["", _] -> {:error, "expected hours"}
      [_, ""] -> {:error, "expected minutes"}
      [hours, minutes] -> convert_to_minutes(hours, minutes)
    end
  end

  defp parse_format("m", _tail, duration_string) do
    case duration_string |> String.trim() |> Integer.parse() do
      {minutes, "m"} -> {:ok, minutes}
      _ -> {:error, "expected minutes"}
    end
  end

  defp parse_format(".", _tail, duration_string) do
    case duration_string |> String.trim() |> Float.parse() do
      {hours, ""} -> {:ok, Kernel.round(hours * 60)}
      {hours, "h"} -> {:ok, Kernel.round(hours * 60)}
      _ -> {:error, "expected 2 digits"}
    end
  end

  defp parse_format("h", _tail, duration_string) do
    case String.split(duration_string, "h") do
      ["", _] -> {:error, "expected hours"}
      [hours, ""] -> convert_to_minutes(hours)
      [hours, minutes] -> convert_to_minutes(hours, minutes)
    end
  end

  defp parse_format(_, tail, duration_string) do
    detect_format(tail, duration_string)
  end
end
