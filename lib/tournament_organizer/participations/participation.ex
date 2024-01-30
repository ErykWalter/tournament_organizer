defmodule TournamentOrganizer.Participations.Participation do
  use Ecto.Schema
  import Ecto.Changeset

  schema "participations" do
    field :ranking, :integer
    field :licence_number, :string
    belongs_to :user, TournamentOrganizer.Users.User
    belongs_to :tournament, TournamentOrganizer.Tournaments.Tournament

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(participation, attrs) do
    participation
    |> cast(attrs, [:ranking, :licence_number, :user_id, :tournament_id])
    |> validate_required([:ranking, :licence_number, :user_id, :tournament_id])
    |> unique_constraint([:user_id, :tournament_id])
    |> dbg
  end
end
