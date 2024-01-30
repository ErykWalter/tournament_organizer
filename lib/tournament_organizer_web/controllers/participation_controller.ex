defmodule TournamentOrganizerWeb.ParticipationController do
  use TournamentOrganizerWeb, :controller

  alias TournamentOrganizer.Participations
  alias TournamentOrganizer.Participations.Participation
  alias TournamentOrganizer.Tournaments

  def index(conn, _params) do
    participations = Participations.list_participations_by_user(conn.assigns.current_user.id)
    render(conn, :index, participations: participations)
  end

  def new(conn, %{"tournament_id" => tournament_id}) do
    tournament = Tournaments.get_tournament!(tournament_id)

    changeset =
      %Participation{}
      |> Participations.change_participation(%{
        tournament_id: tournament_id,
        user_id: conn.assigns.current_user.id
      })

    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"participation" => participation_params}) do
    case Participations.create_participation(participation_params) do
      {:ok, participation} ->
        conn
        |> put_flash(:info, "Participation created successfully.")
        |> redirect(to: ~p"/participations/#{participation}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    participation = Participations.get_participation!(id)
    render(conn, :show, participation: participation)
  end

  def edit(conn, %{"id" => id}) do
    participation = Participations.get_participation!(id)
    changeset = Participations.change_participation(participation)
    render(conn, :edit, participation: participation, changeset: changeset)
  end

  def update(conn, %{"id" => id, "participation" => participation_params}) do
    participation = Participations.get_participation!(id)

    case Participations.update_participation(participation, participation_params) do
      {:ok, participation} ->
        conn
        |> put_flash(:info, "Participation updated successfully.")
        |> redirect(to: ~p"/participations/#{participation}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, participation: participation, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    participation = Participations.get_participation!(id)
    {:ok, _participation} = Participations.delete_participation(participation)

    conn
    |> put_flash(:info, "Participation deleted successfully.")
    |> redirect(to: ~p"/participations")
  end
end
