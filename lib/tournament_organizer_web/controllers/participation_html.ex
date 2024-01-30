defmodule TournamentOrganizerWeb.ParticipationHTML do
  use TournamentOrganizerWeb, :html

  embed_templates "participation_html/*"

  @doc """
  Renders a participation form.
  """
  attr :changeset, Ecto.Changeset, required: true
  attr :action, :string, required: true

  def participation_form(assigns)
end
