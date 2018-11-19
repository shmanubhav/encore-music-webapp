# This will be the room server.
# References Nat Tuck's lecture Notes
# http://www.ccs.neu.edu/home/ntuck/courses/2018/09/cs4550/notes/09-two-players/notes.html

defmodule Las.RoomServer do
  use GenServer
  alias Las.Room

  ## Client Interface
  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  #IMPLEMENTATION
  def init(args) do
    {:ok, args}
  end


end
