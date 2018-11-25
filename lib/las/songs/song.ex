defmodule Las.Songs.Song do
  use Ecto.Schema
  import Ecto.Changeset

  schema "songs" do
    field :author, :string
    field :playing, :boolean, default: false
    field :title, :string, null: false
    field :uri, :string, null: false

    timestamps()
  end

  @doc false
  def changeset(song, attrs) do
    song
    |> cast(attrs, [:title, :author, :playing, :uri])
    |> unique_constraint(:uri)
    |> validate_required([:title, :uri])
  end

  def recently_played(access_token) do
    client = Spotify.client(access_token)

    case OAuth2.Client.get(client, "/v1/me/player/recently-played?limit=10") do
      {:error, error} ->
        {:error, "session expired"}
      {:ok, response} ->
        %{body: songs} = response
        songs_list =  %{songs: Enum.map(songs["items"], fn x -> %{title: x["track"]["name"], uri: x["track"]["uri"], artists: Enum.map(x["track"]["artists"],
        fn y-> %{name: y["name"]} end)} end)}
        {:songs, songs_list}
        end
  end
end
