defmodule TournamentOrganizer.Participations do
  @moduledoc """
  The Participations context.
  """

  import Ecto.Query, warn: false
  alias TournamentOrganizer.Repo

  alias TournamentOrganizer.Participations.Participation
  alias TournamentOrganizer.Tournaments

  @doc """
  Returns the list of participations.

  ## Examples

      iex> list_participations()
      [%Participation{}, ...]

  """
  def list_participations do
    Repo.all(Participation)
  end

  def list_participations_by_user(user_id) do
    Repo.all(from p in Participation, where: p.user_id == ^user_id) |> Repo.preload(:tournament)
  end

  @doc """
  Gets a single participation.

  Raises `Ecto.NoResultsError` if the Participation does not exist.

  ## Examples

      iex> get_participation!(123)
      %Participation{}

      iex> get_participation!(456)
      ** (Ecto.NoResultsError)

  """
  def get_participation!(id), do: Repo.get!(Participation, id) |> Repo.preload(:tournament)

  @doc """
  Creates a participation.

  ## Examples

      iex> create_participation(%{field: value})
      {:ok, %Participation{}}

      iex> create_participation(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_participation(attrs \\ %{}) do
    Repo.transaction(fn ->
      case %Participation{}
           |> Participation.changeset(attrs)
           |> Repo.insert() do
        {:ok, %{id: id, tournament_id: tournament_id}} ->
          if Tournaments.partipants_exceed_limit?(
               tournament_id,
               count_participants_for_tournament(tournament_id)
             ) do
            Repo.rollback("Maximum number of participants reached")
          else
            id
          end

        {:error, changeset} ->
          Repo.rollback(changeset)
      end
    end)
    |> dbg
  end

  @doc """
  Updates a participation.

  ## Examples

      iex> update_participation(participation, %{field: new_value})
      {:ok, %Participation{}}

      iex> update_participation(participation, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_participation(%Participation{} = participation, attrs) do
    participation
    |> Participation.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a participation.

  ## Examples

      iex> delete_participation(participation)
      {:ok, %Participation{}}

      iex> delete_participation(participation)
      {:error, %Ecto.Changeset{}}

  """
  def delete_participation(%Participation{} = participation) do
    Repo.delete(participation)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking participation changes.

  ## Examples

      iex> change_participation(participation)
      %Ecto.Changeset{data: %Participation{}}

  """
  def change_participation(%Participation{} = participation, attrs \\ %{}) do
    Participation.changeset(participation, attrs)
  end

  def already_participate?(tournament_id, user_id) do
    Repo.one(
      from p in Participation, where: p.tournament_id == ^tournament_id and p.user_id == ^user_id
    )
  end

  defp count_participants_for_tournament(tournament_id) do
    Repo.one(
      from p in Participation, where: p.tournament_id == ^tournament_id, select: count(p.id)
    )
  end
end
