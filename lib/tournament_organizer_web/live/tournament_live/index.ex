defmodule TournamentOrganizerWeb.TournamentLive.Index do
  use TournamentOrganizerWeb, :live_view

  require Logger
  alias TournamentOrganizer.Tournaments
  alias TournamentOrganizer.Tournaments.Tournament

  @impl true
  def mount(_params, _session, socket) do
    page_size = 10
    tournaments_query = get_tournaments_query("")

    total_tournaments_count =
      tournaments_query
      |> Tournaments.count_tournaments()

    tournaments =
      tournaments_query
      |> Tournaments.fetch_page(1, page_size)
      |> Tournaments.list_tournaments()

    socket =
      socket
      |> assign(:page_size, 10)
      |> assign(:page_number, 1)
      |> assign(:max_pages, total_tournaments_count / page_size)
      |> assign(name_search: to_form(%{"name" => ""}))
      |> assign(name: "")
      |> assign(:tournaments, tournaments)

    {:ok, socket}
  end

  @impl true
  def handle_params(%{"page" => page, "name" => name}, _url, socket) do
    process_params(name, String.to_integer(page), socket.assigns.page_size, socket)
  end

  def handle_params(%{"page" => page}, _url, socket) do
    process_params(socket.assigns.name, String.to_integer(page), socket.assigns.page_size, socket)
  end

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
    {:noreply, socket}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    tournament = Tournaments.get_tournament!(id)
    {:ok, _} = Tournaments.delete_tournament(tournament)

    {:noreply, socket}
  end

  def handle_event("filter", %{"name" => name}, socket) do
    page = 1

    socket =
      socket
      |> assign(:name, name)
      |> assign(name_search: to_form(%{"name" => name}))
   
    {:noreply, push_patch(socket, to: ~p"/?page=#{page}", replace: true)}
  end

  defp get_tournaments_query(name) when is_binary(name) do
    Tournaments.filter_tournaments_by_date(nil, Date.utc_today())
    |> Tournaments.filter_tournaments_by_name(name)
    |> Tournaments.order_tournaments()
  end

  defp process_params(name, page, page_size, socket) do
    tournaments_query =
      get_tournaments_query(name)

    tournaments =
      tournaments_query
      |> Tournaments.fetch_page(page, page_size)
      |> Tournaments.list_tournaments()

    total_tournaments_count =
      tournaments_query
      |> Tournaments.count_tournaments()

    socket =
      socket
      |> assign(:page_number, page)
      |> assign(:tournaments, tournaments)
      |> assign(:max_pages, total_tournaments_count / page_size)

    {:noreply, socket}
  end
end
