defmodule TournamentOrganizerWeb.TournamentLive.Index do
  use TournamentOrganizerWeb, :live_view

  alias TournamentOrganizer.Tournaments
  alias TournamentOrganizer.Tournaments.Tournament

  @impl true
  def mount(_params, _session, socket) do
    tournaments =
      Tournaments.get_future_filtered_tournaments("", 1, 10)

    socket =
      socket
      |> assign(:page_size, 10)
      |> assign(:page_number, 1)
      |> assign(:items_count, tournaments |> length())
      |> assign(name_search: to_form(%{"name" => ""}))
      |> assign(name: "")

    {:ok, stream(socket, :tournaments, tournaments)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Tournament")
    |> assign(:tournament, Tournaments.get_tournament!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Tournament")
    |> assign(:tournament, %Tournament{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Tournaments")
    |> assign(:tournament, nil)
  end

  @impl true
  def handle_info(
        {TournamentOrganizerWeb.TournamentLive.FormComponent, {:saved, tournament}},
        socket
      ) do
    {:noreply, stream_insert(socket, :tournaments, tournament)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    tournament = Tournaments.get_tournament!(id)
    {:ok, _} = Tournaments.delete_tournament(tournament)

    {:noreply, stream_delete(socket, :tournaments, tournament)}
  end

  def handle_event("next_page", _params, socket) do
    change_current_page(1, socket)
  end

  def handle_event("prev_page", _params, socket) do
    change_current_page(-1, socket)
  end

  defp change_current_page(amount, socket) when is_integer(amount) do
    socket =
      socket
      |> assign(:page_number, max(socket.assigns.page_number + amount, 0))

    tournaments =
      Tournaments.get_future_filtered_tournaments(
        socket.assigns.name,
        socket.assigns.page_number,
        socket.assigns.page_size
      )

    {:noreply, stream(socket, :tournaments, tournaments, reset: true)}
  end

  def handle_event("filter", %{"name" => name}, socket) do
    tournaments =
      Tournaments.get_future_filtered_tournaments(
        name,
        socket.assigns.page_number,
        socket.assigns.page_size
      )

    socket =
      socket
      |> assign(:page_number, 1)
      |> assign(:items_count, tournaments |> length())
      |> assign(:name, name)
      |> assign(name_search: to_form(%{"name" => name}))

    {:noreply, stream(socket, :tournaments, tournaments, reset: true)}
  end
end
