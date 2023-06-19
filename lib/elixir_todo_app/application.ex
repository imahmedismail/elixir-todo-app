defmodule ElixirTodoApp.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      ElixirTodoAppWeb.Telemetry,
      # Start the Ecto repository
      ElixirTodoApp.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: ElixirTodoApp.PubSub},
      # Start Finch
      {Finch, name: ElixirTodoApp.Finch},
      # Start the Endpoint (http/https)
      ElixirTodoAppWeb.Endpoint
      # Start a worker by calling: ElixirTodoApp.Worker.start_link(arg)
      # {ElixirTodoApp.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixirTodoApp.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ElixirTodoAppWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
