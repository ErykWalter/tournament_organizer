defmodule TournamentOrganizer.Repo.Migrations.CreateTournaments do
  use Ecto.Migration

  def change do
    create table(:tournaments) do
      add :name, :string
      add :application_deadline, :utc_datetime
      add :max_participants, :integer
      add :start_date, :utc_datetime

      timestamps(type: :utc_datetime)
    end

    create unique_index(:tournaments, [:name])
  end
end
