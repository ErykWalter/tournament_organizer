defmodule TournamentOrganizer.Ladder.Initializer do
  alias TournamentOrganizer.Participations
  alias TournamentOrganizer.Matches

  def init_ladder(tournament_id) when is_integer(tournament_id) do
    participations = Participations.list_participations_by_tournament(tournament_id)
    matches = init_ladder(participations)

    for {participation1, participation2} <- matches do
      partcipation1_id = if participation1, do: participation1.id, else: nil
      partcipation2_id = if participation2, do: participation2.id, else: nil

      %{
        participant1_id: partcipation1_id,
        participant2_id: partcipation2_id,
        score1: nil,
        score2: nil,
        abs_score: nil,
        tournament_id: tournament_id
      }
      |> Matches.create_match()
    end
    |> dbg()
  end

  def init_ladder(participations) do
    # Sort participations by ranking in ascending order
    sorted_participations = Enum.sort_by(participations, & &1.ranking)

    # Create initial matches for the bracket
    {matches, _} =
      Enum.reduce_while(sorted_participations, {[], sorted_participations}, fn participation,
                                                                               {matches, waiting} ->
        [best | rest] = waiting
        {worst, rest} = List.pop_at(rest, -1)
        matches = [{best, worst} | matches]

        case rest do
          [] ->
            {:halt, {matches, []}}

          _ ->
            {:cont, {matches, rest}}
        end
      end)

    matches |> dbg()
  end

  def is_initialized?(tournament_id) do
    case Matches.list_matches_by_tournament(tournament_id) do
      [] -> false
      _ -> true
    end
  end
end
