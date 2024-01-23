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
end
