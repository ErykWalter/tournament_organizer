defmodule TournamentOrganizer.MatchesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TournamentOrganizer.Matches` context.
  """

  @doc """
  Generate a match.
  """
  def match_fixture(attrs \\ %{}) do
    {:ok, match} =
      attrs
      |> Enum.into(%{
        abs_score: 42,
        score1: true,
        score2: true
      })
      |> TournamentOrganizer.Matches.create_match()

    match
  end
end
