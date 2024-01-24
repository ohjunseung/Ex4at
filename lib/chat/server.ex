defmodule Chat.Server do
  @moduledoc """
  Message handler
  """
  require Logger
  use ThousandIsland.Handler

  @impl true
  def handle_connection(socket, _state) do
    metadata = socket.span.start_metadata
    {{i, j, k, l}, port} = {metadata.remote_address, metadata.remote_port}
    addr = "#{i}.#{j}.#{k}.#{l}:#{port}"
    Logger.info("#{addr} connected")
    GenServer.cast(Chat.Responder, %Chat.User{addr: addr, pid: self()})
    {:continue, %{addr: addr}}
  end

  @impl true
  def handle_data(data, socket, state) do
    if String.valid?(data) do
      msg = %Chat.Message{from: state.addr, message: data}
      GenServer.cast(Chat.Responder, msg)
      {:continue, state}
    else
      ThousandIsland.Socket.send(socket, "Please use valid UTF-8")
      {:close, state}
    end
  end

  @impl true
  def handle_close(_socket, state) do
    Logger.info("#{state.addr} disconnected")
  end

  @impl true
  def handle_cast(data = %Chat.Message{}, s = {socket, _state}) do
    ThousandIsland.Socket.send(socket, data.message)
    {:noreply, s}
  end
end
