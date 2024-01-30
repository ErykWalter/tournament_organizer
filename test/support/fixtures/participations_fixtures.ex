defmodule TournamentOrganizer.ParticipationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TournamentOrganizer.Participations` context.
  """

  @doc """
  Generate a participation.
  """
  def participation_fixture(attrs \\ %{}) do
    {:ok, participation} =
      attrs
      |> Enum.into(%{
        licence_number: "some licence_number",
        ranking: 42
      })
      |> TournamentOrganizer.Participations.create_participation()

    participation
  end
end
