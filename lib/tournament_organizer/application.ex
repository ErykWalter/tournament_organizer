defmodule TournamentOrganizer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      TournamentOrganizerWeb.Telemetry,
      TournamentOrganizer.Repo,
      {DNSCluster,
       query: Application.get_env(:tournament_organizer, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: TournamentOrganizer.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: TournamentOrganizer.Finch},
      # Start a worker by calling: TournamentOrganizer.Worker.start_link(arg)
      # {TournamentOrganizer.Worker, arg},
      # Start to serve requests, typically the last entry
      TournamentOrganizerWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TournamentOrganizer.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TournamentOrganizerWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
