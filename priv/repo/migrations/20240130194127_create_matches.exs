defmodule TournamentOrganizer.Repo.Migrations.CreateMatches do
  use Ecto.Migration

  def change do
    create table(:matches) do
      add :score1, :boolean, default: nil, null: true
      add :score2, :boolean, default: nil, null: true
      add :abs_score, :integer, default: nil, null: true
      add :participant1_id, references(:participations, on_delete: :delete_all), null: true
      add :participant2_id, references(:participations, on_delete: :delete_all), null: true
      add :tournament_id, references(:tournaments, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:matches, [:participant1_id])
    create index(:matches, [:participant2_id])
    create unique_index(:matches, [:participant1_id, :participant2_id])
  end
end
