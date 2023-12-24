defmodule TournamentOrganizer.Tournaments.Tournament do
  use Ecto.Schema
  import Ecto.Changeset
  alias TournamentOrganizer.Accounts

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
    |> validate_change(:application_deadline, fn :application_deadline, application_deadline ->
      if Date.compare(application_deadline, Date.utc_today()) == :lt do
        [application_deadline: "Application deadline cannot be in the past"]
      else
        []
      end
    end)
    |> validate_change(:start_date, fn :start_date, start_date ->
      if DateTime.compare(start_date, DateTime.utc_now()) == :lt do
        [start_date: "Start date cannot be in the past"]
      else
        []
      end
    end)
    |> validate_dates()
    |> validate_user_id()
    |> unique_constraint(:name)
  end

  @spec validate_dates(Ecto.Changeset.t()) :: Ecto.Changeset.t()
  defp validate_dates(
         %{start_date: start_date, application_deadline: application_deadline} = changeset
       )
       when start_date != nil and application_deadline != nil do
    if Date.compare(DateTime.to_date(start_date), application_deadline) != :lt do
      changeset
    else
      add_error(changeset, :start_date, "Start date cannot be before application deadline")
    end
  end

  defp validate_dates(changeset) do
    changeset
  end

  defp validate_user_id(changeset) do
    user_id = get_field(changeset, :user_id)

    cond do
      user_id == nil -> add_error(changeset, :user_id, "User ID must be specified")
      not Accounts.user_exists?(user_id) -> add_error(changeset, :user_id, "Wrong user")
      true -> changeset
    end
  end
end
