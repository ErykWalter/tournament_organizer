defmodule TournamentOrganizer.Tournaments do
  @moduledoc """
  The Tournaments context.
  """
  @type optional_query_param :: Ecto.Query.t() | nil

  import Ecto.Query, warn: false
  alias TournamentOrganizer.Repo
  alias TournamentOrganizer.SponsorLogo

  alias TournamentOrganizer.Tournaments.Tournament

  def list_tournaments() do
    Tournament
    |> Repo.all()
  end

  @spec list_tournaments(Ecto.Query.t() | nil) :: Ecto.Query.t()
  def list_tournaments(query) do
    (query || Tournament)
    |> Repo.all()
  end

  @spec order_tournaments(optional_query_param, atom) :: Ecto.Query.t()
  def order_tournaments(query, field \\ :name) do
    (query || Tournament)
    |> order_by(asc: ^field)
  end

  @spec filter_tournaments_by_date(optional_query_param, Date.t()) :: Ecto.Query.t()
  def filter_tournaments_by_date(query, %Date{} = date) do
    (query || Tournament)
    |> where([t], t.application_deadline >= ^date)
    |> where([t], t.start_date >= ^DateTime.new!(date, Time.utc_now()))
  end

  def filter_tournaments_by_name(query, name) when is_binary(name) do
    (query || Tournament)
    |> where([t], ilike(t.name, ^"%#{name}%"))
  end

  @spec fetch_page(optional_query_param, Integer, Integer) :: Ecto.Query.t()
  def fetch_page(query, page_number, page_size) do
    (query || Tournament)
    |> limit(^page_size)
    |> offset(^page_size * (^page_number - 1))
  end

  @doc """
  Gets tournaments ready to be displayed on the index page.
  """
  @spec get_future_filtered_tournaments(String.t(), Integer.t(), Integer.t()) :: [term()]
  def get_future_filtered_tournaments(name, page_number, page_size) do
    Tournament
    |> filter_tournaments_by_name(name)
    |> filter_tournaments_by_date(Date.utc_today())
    |> order_tournaments()
    |> fetch_page(page_number, page_size)
    |> Repo.all()
  end

  def count_tournaments() do
    Tournament
    |> Repo.aggregate(:count, :id)
  end

  def count_tournaments(query) do
    (query || Tournament)
    |> Repo.aggregate(:count)
  end

  def preload_user(tournament) do
    Repo.preload(tournament, :user)
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
