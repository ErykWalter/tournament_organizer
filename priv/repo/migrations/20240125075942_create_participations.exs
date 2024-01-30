defmodule TournamentOrganizer.Repo.Migrations.CreateParticipations do
  use Ecto.Migration

  def change do
    create table(:participations) do
      add :ranking, :integer
      add :licence_number, :string
      add :user_id, references(:users, on_delete: :delete_all)
      add :tournament_id, references(:tournaments, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create index(:participations, [:user_id])
    create index(:participations, [:tournament_id])
    create unique_index(:participations, [:user_id, :tournament_id])
  end
end
