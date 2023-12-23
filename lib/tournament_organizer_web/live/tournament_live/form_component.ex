defmodule TournamentOrganizerWeb.TournamentLive.FormComponent do
  use TournamentOrganizerWeb, :live_component

  alias TournamentOrganizer.Tournaments

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage tournament records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="tournament-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <:actions>
          <.button phx-disable-with="Saving...">Save Tournament</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{tournament: tournament} = assigns, socket) do
    changeset = Tournaments.change_tournament(tournament)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"tournament" => tournament_params}, socket) do
    changeset =
      socket.assigns.tournament
      |> Tournaments.change_tournament(tournament_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"tournament" => tournament_params}, socket) do
    save_tournament(socket, socket.assigns.action, tournament_params)
  end

  defp save_tournament(socket, :edit, tournament_params) do
    case Tournaments.update_tournament(socket.assigns.tournament, tournament_params) do
      {:ok, tournament} ->
        notify_parent({:saved, tournament})

        {:noreply,
         socket
         |> put_flash(:info, "Tournament updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_tournament(socket, :new, tournament_params) do
    case Tournaments.create_tournament(tournament_params) do
      {:ok, tournament} ->
        notify_parent({:saved, tournament})

        {:noreply,
         socket
         |> put_flash(:info, "Tournament created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
