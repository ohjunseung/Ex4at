defmodule Chat.Supervisor do
  use Supervisor

  def start_link(args) do
    Supervisor.start_link(__MODULE__, args)
  end

  @impl true
  def init(_) do
    children = [
      {
        ThousandIsland,
        port: 3000, handler_module: Chat.Server
      },
      Chat.Responder
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end

defmodule Chat.Application do
  use Application

  @impl true
  def start(_type, _args) do
    children = [Chat.Supervisor]
    Supervisor.start_link(children, strategy: :one_for_one)
  end
end
