defmodule Las.Users.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :admin, :boolean, default: false
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :password_hash, :string
    belongs_to :room, Las.Rooms.Room

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :first_name, :last_name, :password_hash, :admin])
    |> validate_required([:email, :first_name, :last_name, :password_hash, :admin])
  end
end
