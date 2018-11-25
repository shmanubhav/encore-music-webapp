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

    LasWeb.Endpoint.broadcast("games:" <> game, "change_view", vv)
    {:reply, vv, Map.put(state, game, gg)}

  end

end
