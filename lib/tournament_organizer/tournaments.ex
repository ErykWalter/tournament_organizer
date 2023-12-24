defmodule TournamentOrganizer.Tournaments do
  @moduledoc """
  The Tournaments context.
  """

  @type optional_query_param :: Ecto.Query.t() | nil

  import Ecto.Query, warn: false
  alias TournamentOrganizer.Repo

  alias TournamentOrganizer.Tournaments.Tournament

  def list_tournaments() do
    Tournament
    |> Repo.all()
  end

  @spec list_tournaments(optional_query_param) :: Ecto.Query.t()
  def list_tournaments(nil) do
    Tournament
    |> Repo.all()
  end

  def list_tournaments(query) do
    query
    |> Repo.all()
  end

  @spec order_tournaments(optional_query_param, atom) :: Ecto.Query.t()
  def order_tournaments(query, field \\ :name) do
    query
    |> handle_query_argument()
    |> order_by(asc: ^field)
  end

  @spec filter_tournaments_by_date(optional_query_param, Date.t()) :: Ecto.Query.t()
  def filter_tournaments_by_date(query, %Date{} = date) do
    query
    |> handle_query_argument()
    |> where([t], t.application_deadline >= ^date)
  end

  @spec filter_tournaments_by_name(optional_query_param, name :: String.t()) :: Ecto.Query.t()
  def filter_tournaments_by_name(query, name) when is_binary(name) do
    query
    |> handle_query_argument()
    |> where([t], ilike(t.name, ^"%#{name}%"))
  end

  @spec fetch_page(optional_query_param, Integer, Integer) :: Ecto.Query.t()
  def fetch_page(query, page_number, page_size) do
    query
    |> handle_query_argument()
    |> limit(^page_size)
    |> offset(^page_size * (^page_number - 1))
  end

  def preload_user(tournament) do
    Repo.preload(tournament, :user)
  end

  @spec handle_query_argument(Ecto.Query.t() | Atom) :: Ecto.Query.t()
  defp handle_query_argument(nil) do
    Tournament
  end

  defp handle_query_argument(%Ecto.Query{} = query) do
    query
  end

  @doc """
  Gets a single tournament.

  Raises `Ecto.NoResultsError` if the Tournament does not exist.

  ## Examples

      iex> get_tournament!(123)
      %Tournament{}

      iex> get_tournament!(456)
      ** (Ecto.NoResultsError)

  """
  def get_tournament!(id), do: Repo.get!(Tournament, id)

  @doc """
  Creates a tournament.

  ## Examples

      iex> create_tournament(%{field: value})
      {:ok, %Tournament{}}

      iex> create_tournament(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_tournament(attrs \\ %{}) do
    %Tournament{}
    |> Tournament.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a tournament.

  ## Examples

      iex> update_tournament(tournament, %{field: new_value})
      {:ok, %Tournament{}}

      iex> update_tournament(tournament, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_tournament(%Tournament{} = tournament, attrs) do
    tournament
    |> Tournament.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a tournament.

  ## Examples

      iex> delete_tournament(tournament)
      {:ok, %Tournament{}}

      iex> delete_tournament(tournament)
      {:error, %Ecto.Changeset{}}

  """
  def delete_tournament(%Tournament{} = tournament) do
    Repo.delete(tournament)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking tournament changes.

  ## Examples

      iex> change_tournament(tournament)
      %Ecto.Changeset{data: %Tournament{}}

  """
  def change_tournament(%Tournament{} = tournament, attrs \\ %{}) do
    Tournament.changeset(tournament, attrs)
  end
end
