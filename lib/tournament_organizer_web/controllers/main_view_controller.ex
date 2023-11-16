defmodule TournamentOrganizerWeb.MainViewController do
  use TournamentOrganizerWeb, :controller

  def main_view(conn, _params) do
    render(conn, :main_view)
  end

  def tournament_view(conn, %{"tournament_id" => id}) do
    render(conn, :tournament_view, id: id)
  end
end
