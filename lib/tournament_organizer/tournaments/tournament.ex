defmodule TournamentOrganizer.Tournaments.Tournament do
  use Ecto.Schema
  import Ecto.Changeset

  @type tournament :: %__MODULE__{
    __meta__: Ecto.Schema.Metadata.t(),
    application_deadline: Date.t(),
    id: integer(),
    inserted_at: DateTime.t(),
    max_participants: integer(),
    name: String.t(),
    user: TournamentOrganizer.Accounts.User.t(),
    user_id: integer(),
    start_date: DateTime.t(),
    updated_at: DateTime.t()
  }

  schema "tournaments" do
    field :name, :string
    field :application_deadline, :date
    field :max_participants, :integer
    field :start_date, :utc_datetime
    belongs_to :user, TournamentOrganizer.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  @spec changeset(tournament, map) :: Ecto.Changeset.t()
  def changeset(tournament, attrs) do
    tournament
    |> cast(attrs, [:name, :max_participants, :application_deadline, :start_date, :user_id])
    |> validate_required([:name, :application_deadline, :max_participants, :start_date, :user_id])
    |> validate_number(:max_participants, greater_than: 0)
    |> validate_change(:application_deadline, fn _, application_deadline ->
      if application_deadline < Date.utc_today() do
        [:error, "Application deadline cannot be in the past"]
      else
        []
      end
    end)
    |> validate_change(:start_date, fn :start_date, start_date ->
      if start_date < DateTime.utc_now() do
        [:error, "Start date cannot be in the past"]
      else
        []
      end
    end)
  end
end
