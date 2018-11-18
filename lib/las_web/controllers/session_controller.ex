# Used for Reference: Nat Tuck's lecture Notes
# http://www.ccs.neu.edu/home/ntuck/courses/2018/09/cs4550/notes/11-add-users/notes.html

defmodule LasWeb.SessionController do
  use LasWeb, :controller

  def create(conn, %{"email" => email, "password" => password}) do

    user = Las.Users.get_user_and_auth(email, password)
    if user do
      conn
      |> put_session(:user_id, user.id)
      |> put_flash(:info, "Welcome back #{user.email}")
      |> redirect(to: Routes.page_path(conn, :index))
    else
      conn
      |> put_flash(:error, "Login failed.")
      |> redirect(to: Routes.page_path(conn, :index))
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:user_id)
    |> put_flash(:info, "Logged out.")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
