defmodule TournamentOrganizerWeb.TournamentController do
  use TournamentOrganizerWeb, :controller

  require Logger
  alias TournamentOrganizer.Tournaments
  alias TournamentOrganizer.Tournaments.Pager
  alias TournamentOrganizer.Tournaments.Tournament

  def index(conn, params) do
    page = Map.get(params, "page", "1") |> String.to_integer()
    name = Map.get(params, "search", "")
    page = Pager.get_tournaments(name, page)
    page = Map.put(page, :search, name) |> dbg()
    Logger.debug("Page: #{inspect(page)}")
    render(conn, :index, page)
  end

  def new(conn, _params) do
    changeset = Tournaments.change_tournament(%Tournament{})
    Logger.debug("New tournament changeset: #{inspect(changeset)}")
    render(conn, :new, changeset: changeset) |> dbg()
  end

  def create(conn, %{"tournament" => tournament_params}) do
    tournament_params = Map.put(tournament_params, "user_id", conn.assigns.current_user.id)
    start_date = Map.get(tournament_params, "start_date") <> "00Z"
    Map.put(tournament_params, "start_date", start_date)

    case Tournaments.create_tournament(tournament_params) do
      {:ok, tournament} ->
        conn
        |> put_flash(:info, "Tournament created successfully.")
        |> redirect(to: ~p"/tournaments/#{tournament}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    tournament = 
      Tournaments.get_tournament!(id)
      |> Tournaments.preload_user()
      |> dbg()
    render(conn, :show, tournament: tournament)
  end

  def edit(conn, %{"id" => id}) do
    tournament = Tournaments.get_tournament!(id)
    changeset = Tournaments.change_tournament(tournament)
    render(conn, :edit, tournament: tournament, changeset: changeset)
  end

  def update(conn, %{"id" => id, "tournament" => tournament_params}) do
    tournament = Tournaments.get_tournament!(id)

    case Tournaments.update_tournament(tournament, tournament_params) do
      {:ok, tournament} ->
        conn
        |> put_flash(:info, "Tournament updated successfully.")
        |> redirect(to: ~p"/tournaments/#{tournament}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, tournament: tournament, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    tournament = Tournaments.get_tournament!(id)
    {:ok, _tournament} = Tournaments.delete_tournament(tournament)

    conn
    |> put_flash(:info, "Tournament deleted successfully.")
    |> redirect(to: ~p"/")
  end
end
