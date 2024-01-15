defmodule TournamentOrganizer.TournamentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TournamentOrganizer.Tournaments` context.
  """

  @doc """
  Generate a tournament.
  """
  def tournament_fixture(attrs \\ %{}) do
    {:ok, tournament} =
      attrs
      |> Enum.into(%{})
      |> TournamentOrganizer.Tournaments.create_tournament()

    tournament
  end
end
