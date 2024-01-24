defmodule Chat.Responder do
  @moduledoc """
  Message brodcast and responder 
  """

  use GenServer
  require Logger

  def start_link(args) do
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  @impl true
  def init(_) do
    {:ok, %{users: []}}
  end

  @impl true
  def handle_cast(data = %Chat.Message{}, state) do
    broadcast(state.users, data)
    Logger.info("#{data.from}->#{data.message}")
    {:noreply, state}
  end

  @impl true
  def handle_cast(user = %Chat.User{}, state) do
    new_users = [user | state.users]
    {:noreply, Map.put(state, :users, new_users)}
  end

  def broadcast([], _) do
  end

  def broadcast([user | tail], data) do
    if user.addr !== data.from do
      GenServer.cast(user.pid, data)
    end

    broadcast(tail, data)
  end
end
