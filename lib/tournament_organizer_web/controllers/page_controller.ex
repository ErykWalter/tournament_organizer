defmodule TournamentOrganizerWeb.PageController do
  use TournamentOrganizerWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    data = TournamentOrganizer.Tournaments.list_tournaments()
    render(conn, :home, layout: false, data: data)
  end
end
