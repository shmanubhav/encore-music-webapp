defmodule LasWeb.PageController do
  use LasWeb, :controller

  alias Las.Rooms
  alias Las.RoomUsers

  def index(conn, _params) do
    user = get_session(conn, :current_user)
    if user do
      conn
      |> redirect(to: "/explore")
    else
      render(conn, "index.html")
    end
  end

  def explore(conn, _params) do
    recently_played = get_session(conn, :recently_played).songs
    render(conn, "explore.html", recent_songs: recently_played)
  end

  def enter(conn, %{"enter" => %{"party_name" => party_name}}) do
    room = Rooms.get_room(party_name)
    user = get_session(conn, :current_login_user)
    cond do
      room && (user.id == room.user_id) ->
        conn
        |> redirect(to: "/party/#{party_name}")
      room ->
        render(conn, "enter.html", party_name: party_name)
      true ->
        conn
        |> put_flash(:error, "Party Does Not Exist")
        |> redirect(to: "/explore")
    end
  end

  def join(conn, %{"join" => %{"party_name" => party_name, "party_code" => party_code}}) do

    # check that the fields are filled out.
    if party_name == "" or party_code == "" do
      conn
      |> put_flash(:error, "Please Enter a Party Room and Code")
      |> redirect(to: "/enter")
    end

    # Validate that the code is correct.
    room = Rooms.validate_code(party_name, party_code)
    user = get_session(conn, :current_login_user)
    if room do
      conn
      |> redirect(to: "/party/#{party_name}")
    else
      conn
      |> put_flash(:error, "Denied joining Party Room: Incorrect room code.")
      |> redirect(to: "/")
    end
  end

  def party(conn, %{"party" => party_name}) do
    user = get_session(conn, :current_login_user)
    spotify_user = get_session(conn, :current_user)
    room = Rooms.get_room(party_name)
    #TODO: check if entry is already in the room user table
    case RoomUsers.create_room_user(%{room_id: room.id, user_id: user.id}) do
      {:ok, roomuser} ->
        conn
        |> put_session(:party_name, party_name)
        |> render("party_room.html", party_name: party_name , user: user, spotify_user: spotify_user)
      {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "/", changeset: changeset)
    end
  end
end
