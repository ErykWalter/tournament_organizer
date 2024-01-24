defmodule TournamentOrganizerWeb.TournamentHTML do
  use TournamentOrganizerWeb, :html

  embed_templates "tournament_html/*"

  @doc """
  Renders a tournament form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def tournament_form(assigns)

  attr :minlon, :string, required: true
  attr :minlat, :string, required: true
  attr :maxlon, :string, required: true
  attr :maxlat, :string, required: true
  attr :lat, :string, required: true
  attr :lon, :string, required: true
  attr :marker, :boolean, required: true
  attr :address, :string, required: true

  def map(assigns)

  attr :tournament, TournamentOrganizer.Tournaments.Tournament, required: true

  def sponsor_grid(assigns) do
    ~H"""
    <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
      <%= for sponsor_logo <- @tournament.sponsor_logos do %>
        <div class="relative flex items-center justify-center p-4 group transition-all duration-300 ease-in-out hover:bg-gray-700 hover:bg-opacity-75">
          <img
            src={"#{TournamentOrganizerWeb.Endpoint.url}#{TournamentOrganizer.SponsorLogo.url({sponsor_logo.url, @tournament}, :thumb)}"}
            alt="Sponsor Logo"
            class="block mx-auto object-contain opacity-90 group-hover:opacity-100 transition-opacity duration-300 ease-in-out"
          />
        </div>
      <% end %>
    </div>
    """
  end
end
