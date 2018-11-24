defmodule Las.RoomSongs.RoomSong do
  use Ecto.Schema
  import Ecto.Changeset

  schema "room_song" do
    belongs_to :song, Las.Songs.Song
    belongs_to :room, Las.Rooms.Room

    timestamps()
  end

  @doc false
  def changeset(roomsong, attrs) do
    roomsong
    |> cast(attrs, [:song_id, :room_id])
  end
end
