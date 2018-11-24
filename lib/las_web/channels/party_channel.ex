# Referenced http://www.ccs.neu.edu/home/ntuck/courses/2018/09/cs4550/notes/06-channels/notes.html
defmodule LasWeb.GamesChannel do
  use LasWeb, :channel

  alias Las.Party
  alias Las.PartyServer
  alias Las.RoomUsers

  def join("Welcome! Party Room:" <> game, payload, socket) do
    if authorized?(payload) do
      socket = assign(socket, :game, game)
      PartyServer.add_user(game, socket.assigns[:user].id)
      view = PartyServer.view(game, socket.assigns[:user])
      IO.inspect(view)
      {:ok, %{"join" => game, "view" => view}, socket}
    else
      {:error, %{reason: "unauthorized"}}
      end
    end

    # Add other actions here

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (games:lobby).
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # Authorization logic here as required.
  defp authorized?(payload) do
    user_id = Map.get(payload, "user")
    room_id = Map.get(payload, "room")

    if user_id != nil and room_id != nil do
      roomuser = RoomUsers.room_contains_user(user_id, room_id)
      if roomuser do
        true
      end
    else
      false
    end
  end
end
