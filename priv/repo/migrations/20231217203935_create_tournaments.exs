defmodule TournamentOrganizer.Repo.Migrations.CreateTournaments do
  use Ecto.Migration

  def change do
    create table(:tournaments) do
      add :name, :string
      add :application_deadline, :date
      add :max_participants, :integer
      add :start_date, :utc_datetime
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:tournaments, [:name])
    create index(:tournaments, [:user_id])
    create constraint(:tournaments, :max_participants, check: "max_participants > 0")
  end
end
