defmodule LasWeb.PageController do
  use LasWeb, :controller

  alias Las.Rooms

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def join(conn, %{"join" => %{"party_name" => party_name, "party_code" => party_code}}) do

    # check that the fields are filled out.
    if party_name == "" or party_code == "" do
      conn
      |> put_flash(:error, "Please Enter a Party Room and Code")
      |> redirect(to: "/")
    end

    # Validate that the code is correct.
    room = Rooms.validate_code(party_name, party_code)

    # TODO Add the user to the room's list of validated users.

    if room do
      conn
      |> put_session(:party_name, party_name)
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

    if user do
      render conn, "party_room.html", party_name: party_name , user: user, spotify_user: spotify_user
    else
      conn
      |> put_flash(:error, "Unable to join Party Room")
      |> redirect(to: "/")
    end
  end

end
