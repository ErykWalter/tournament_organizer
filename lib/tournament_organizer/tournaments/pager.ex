defmodule TournamentOrganizer.Tournaments.Pager do
  import TournamentOrganizer.Tournaments
  alias TournamentOrganizer.Tournaments.Tournament

  def get_tournaments(search_name, page_number, page_size \\ 10) do
    tournaments = get_future_filtered_tournaments(search_name, page_number, page_size)
    total_pages = 
      Tournament
      |> filter_tournaments_by_name(search_name)
      |> filter_tournaments_by_date(Date.utc_today())
      |> count_tournaments()
      |> (fn count -> Float.ceil(count / page_size) end).()
      |> dbg()

    %{page_number: page_number, page_size: page_size, total_pages: total_pages, tournaments: tournaments}
  end
end
