defmodule TournamentOrganizer.Ladder.Format do
  alias TournamentOrganizer.{Participations, Matches}

  def display_ladder(tournament_id) do
    matches = Matches.list_matches_by_tournament(tournament_id)

    rounds =
      for r <- 1..(ceil(:math.log2(length(matches))) + 1) do
        %{name: "Round #{r}"}
      end

    matches_formatted =
      for {match, id} <- Enum.with_index(matches) do
        if match.participant2_id do
          %{
            roundIndex: 0,
            order: id,
            sides: [
              %{
                contestantId: "#{match.participant1.user_id}"
              },
              %{
                contestantId: "#{match.participant2.user_id}"
              }
            ]
          }
        else
          %{
            roundIndex: 0,
            order: id,
            sides: [
              %{
                contestantId: "#{match.participant1.user_id}"
              }
            ]
          }
        end
      end

    contestants =
      matches
      |> Enum.reduce([], fn m, acc ->
        [Map.get(m.participant2 || %{}, :user_id) | [m.participant1.user_id | acc]]
      end)
      |> Enum.filter(& &1)
      |> Enum.map(fn u_id -> TournamentOrganizer.Accounts.get_user!(u_id) end)
      |> Enum.reduce(%{}, fn u, acc ->
        Map.put(acc, "#{u.id}", %{players: [%{title: u.name <> " " <> u.surname}]})
      end)

    %{
      rounds: rounds,
      matches: matches_formatted,
      contestants: contestants
    }
  end
end
