# Referenced http://www.ccs.neu.edu/home/ntuck/courses/2018/09/cs4550/notes/06-channels/notes.html
defmodule LasWeb.GamesChannel do
  use LasWeb, :channel

  alias Las.Party
  alias Las.PartyServer

  def join("Welcome! Party Room:" <> game, payload, socket) do
    if authorized?(payload) do
      socket = assign(socket, :game, game)
      IO.inspect(game)
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

  # TODO Add authorization logic here as required.
  defp authorized?(payload) do
    user_id = Map.get(payload, "user")
    if user_id do
      # TODO make DB call to check that they are authenticated - that the join table
      # between users and rooms contains this user

      true
    else
      false
    end
  end
end
