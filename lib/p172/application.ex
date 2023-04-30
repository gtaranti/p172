defmodule P172.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      P172Web.Telemetry,
      # Start the Ecto repository
      P172.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: P172.PubSub},
      # Start Finch
      {Finch, name: P172.Finch},
      # Start the Endpoint (http/https)
      P172Web.Endpoint
      # Start a worker by calling: P172.Worker.start_link(arg)
      # {P172.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: P172.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    P172Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
