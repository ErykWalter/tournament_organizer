defmodule TournamentOrganizerWeb.TournamentController do
  use TournamentOrganizerWeb, :controller

  require Logger
  require IEx
  alias OpenStreetMap
  alias TournamentOrganizer.Tournaments
  alias TournamentOrganizer.Tournaments.Pager
  alias TournamentOrganizer.Tournaments.Tournament
  alias TournamentOrganizer.Participations
  alias TournamentOrganizer.SponsorLogo
  alias TournamentOrganizer.Ladder

  def index(conn, params) do
    page = Map.get(params, "page", "1") |> String.to_integer()
    name = Map.get(params, "search", "")
    page = Pager.get_tournaments(name, page)
    page = Map.put(page, :search, name) |> dbg()
    Logger.debug("Page: #{inspect(page)}")
    render(conn, :index, page)
  end

  def new(conn, _params) do
    changeset = Tournaments.change_tournament(%Tournament{})
    Logger.debug("New tournament changeset: #{inspect(changeset)}")
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"tournament" => tournament_params}) do
    tournament_params = Map.put(tournament_params, "user_id", conn.assigns.current_user.id)

    case Tournaments.create_tournament(tournament_params) do
      {:ok, tournament_id} ->
        conn
        |> put_flash(:info, "Tournament created successfully.")
        |> redirect(to: ~p"/tournaments/#{tournament_id}")

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> render(:new, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    tournament =
      Tournaments.get_tournament!(id)
      |> Tournaments.preload_user()

    if !Date.before?(Date.utc_today(), tournament.application_deadline) do
      Ladder.Initializer.is_initialized?(tournament.id) ||
        Ladder.Initializer.init_ladder(tournament.id)
    end

    address = tournament.address
    map_info = get_info_for_map_display(address)

    bracket =
      case Ladder.Initializer.is_initialized?(tournament.id) do
        true -> Ladder.Format.display_ladder(tournament.id)
        false -> default_bracket()
      end

    already_participate? =
      if conn.assigns.current_user do
        Participations.already_participate?(tournament.id, conn.assigns.current_user.id)
      else
        false
      end

    render(conn, :show,
      tournament: tournament,
      map_info: map_info,
      address: address,
      bracket: bracket,
      already_participate?: already_participate?
    )
  end

  def edit(conn, %{"id" => id}) do
    tournament = Tournaments.get_tournament!(id)
    changeset = Tournaments.change_tournament(tournament)
    render(conn, :edit, tournament: tournament, changeset: changeset)
  end

  def update(conn, %{"id" => id, "tournament" => tournament_params}) do
    tournament = Tournaments.get_tournament!(id)
    logos = tournament_params["logos"]
    tournament_params = process_logos(logos, tournament, tournament_params)

    case Tournaments.update_tournament(tournament, tournament_params) do
      {:ok, tournament} ->
        conn
        |> put_flash(:info, "Tournament updated successfully.")
        |> redirect(to: ~p"/tournaments/#{tournament}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, :edit, tournament: tournament, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    tournament = Tournaments.get_tournament!(id)
    {:ok, _tournament} = Tournaments.delete_tournament(tournament)

    conn
    |> put_flash(:info, "Tournament deleted successfully.")
    |> redirect(to: ~p"/")
  end

  defp process_logos(logos, tournament, tournament_params) do
    if logos do
      sponsor_logos =
        for logo <- logos do
          case SponsorLogo.store({logo, tournament}) do
            {:ok, name} -> %{url: name}
            _ -> :error
          end
        end

      Map.put(tournament_params, "sponsor_logos", sponsor_logos) |> dbg
    else
      tournament_params
    end
  end

  defp get_info_for_map_display(nil) do
    default_info()
  end

  defp get_info_for_map_display(address) when is_binary(address) do
    case OpenStreetMap.search(q: address, format: "json", accept_language: "en") do
      {:ok, []} -> default_info()
      {:ok, [head | _tail]} -> extract_map_info_from_response(head)
      {:error, _reason} -> default_info()
    end
  end

  defp extract_map_info_from_response(response) do
    case response do
      %{"boundingbox" => [minlat, maxlat, minlon, maxlon], "lat" => lat, "lon" => lon} ->
        %{
          minlon: minlon,
          minlat: minlat,
          maxlon: maxlon,
          maxlat: maxlat,
          lat: lat,
          lon: lon,
          marker: true
        }

      _ ->
        default_info()
    end
  end

  defp default_info() do
    %{
      lat: "52.39427025",
      lon: "16.918130386528922",
      marker: false,
      minlon: "16.9167733",
      minlat: "52.3939514",
      maxlon: "16.9188347",
      maxlat: "52.3949330"
    }
  end

  defp default_bracket() do
    %{
      rounds: [
        %{name: "1st round"},
        %{name: "2nd round"}
      ],
      matches: [
        %{
          roundIndex: 0,
          order: 0,
          sides: [
            %{
              contestantId: "163911",
              scores: [
                %{mainScore: "7", isWinner: true},
                %{mainScore: "6", isWinner: true},
                %{mainScore: "6", isWinner: true}
              ],
              isWinner: true
            },
            %{
              contestantId: "163806",
              scores: [
                %{mainScore: "5"},
                %{mainScore: "2"},
                %{mainScore: "2"}
              ]
            }
          ]
        }
      ],
      contestants: %{
        "163806" => %{
          entryStatus: "4",
          players: [
            %{title: "D. Medvedev"}
          ]
        },
        "163911" => %{
          entryStatus: "1",
          players: [
            %{title: "N. Djokovic"}
          ]
        }
      }
    }
  end
end
