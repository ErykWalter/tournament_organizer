defmodule TournamentOrganizer.Matches.Match do
  use Ecto.Schema
  import Ecto.Changeset

  schema "matches" do
    field :score1, :boolean, default: nil
    field :score2, :boolean, default: nil
    field :abs_score, :integer
    belongs_to :participant1, TournamentOrganizer.Participations.Participation
    belongs_to :participant2, TournamentOrganizer.Participations.Participation
    belongs_to :tournament, TournamentOrganizer.Tournaments.Tournament

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(match, attrs) do
    match
    |> cast(attrs, [
      :score1,
      :score2,
      :abs_score,
      :participant1_id,
      :participant2_id,
      :tournament_id
    ])
    |> validate_required([:participant1_id, :tournament_id])
  end
end
