defmodule Las.Songs.Song do
  use Ecto.Schema
  import Ecto.Changeset

  schema "songs" do
    field :author, :string
    field :playing, :boolean, default: false
    field :title, :string

    timestamps()
  end

  @doc false
  def changeset(song, attrs) do
    song
    |> cast(attrs, [:title, :author, :playing])
    |> validate_required([:title, :author, :playing])
  end

  def recently_played(access_token) do
    client = Spotify.client(access_token)
    %{body: songs} = OAuth2.Client.get!(client, "/v1/me/player/recently-played?limit=10")
    %{songs: Enum.map(songs["items"], fn x -> %{title: x["track"]["name"], artists: Enum.map(x["track"]["artists"],
    fn y-> %{name: y["name"]} end)} end)}
  end
end
