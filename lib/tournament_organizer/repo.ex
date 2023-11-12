defmodule TournamentOrganizer.Repo do
  use Ecto.Repo,
    otp_app: :tournament_organizer,
    adapter: Ecto.Adapters.Postgres
end
