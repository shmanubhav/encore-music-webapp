# This will be the room server.
# Used Nat Tuck's lecture notes for reference
# http://www.ccs.neu.edu/home/ntuck/courses/2018/09/cs4550/notes/09-two-players/notes.html

defmodule Las.PartyServer do
  use GenServer
  alias Las.Party

  ## Client Interface
  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def view(game, user) do
    GenServer.call(__MODULE__, {:view, game, user})
  end

  def set_party_name(game, user) do
    GenServer.call(__MODULE__, {:set_party_name, game, user})
  end

  def add_user(game, user) do
    GenServer.call(__MODULE__, {:new_user, game, user})
  end

  def toggle(game, user) do
    GenServer.call(__MODULE__, {:toggle, game, user})
  end

  def current_song(game, user, song, image) do
    GenServer.call(__MODULE__, {:current_song, game, user, song, image})
  end

  #IMPLEMENTATION
  def init(args) do
    {:ok, args}
  end

  def handle_call({:view, game, user}, _from, state) do
    gg = Map.get(state, game, Party.new)
    {:reply, Party.client_view(gg, user), Map.put(state, game, gg)}
  end

  def handle_call({:set_party_name, game, user}, _from, state) do
    gg = Map.get(state, game, Party.new)
    |> Party.set_party_name(game)
    {:reply, Party.client_view(gg, user), Map.put(state, game, gg)}
  end

  def handle_call({:new_user, game, user}, _from, state) do
    gg = Map.get(state, game, Party.new)
    |> Party.add_user(user)
    vv = Party.client_view(gg, user)

    LasWeb.Endpoint.broadcast("Welcome! Party Room:" <> game, "change_view", vv)
    {:reply, vv, Map.put(state, game, gg)}
  end

  def handle_call({:toggle, game, user}, _from, state) do
    gg = Map.get(state, game, Party.new)
    |> Party.toggle_playing()
    vv = Party.client_view(gg, user)

    LasWeb.Endpoint.broadcast("Welcome! Party Room:" <> game, "change_view", vv)
    {:reply, vv, Map.put(state, game, gg)}
  end

  def handle_call({:current_song, game, user, song, image}, _from, state) do
    gg = Map.get(state, game, Party.new)
    |> Party.current_song(song, image)
    vv = Party.client_view(gg, user)

    LasWeb.Endpoint.broadcast("Welcome! Party Room:" <> game, "change_view", vv)
    {:reply, vv, Map.put(state, game, gg)}
  end

end
