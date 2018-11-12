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
end
