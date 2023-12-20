defmodule TournamentOrganizerWeb.TournamentHTML do
  use TournamentOrganizerWeb, :html

  embed_templates "tournament_html/*"

  @doc """
  Renders a tournament form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def tournament_form(assigns)
end
