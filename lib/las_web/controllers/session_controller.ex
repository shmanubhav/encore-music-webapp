defmodule LasWeb.SessionController do
  use LasWeb, :controller

  def create(conn, %{"email" => email, "password" => password}) do
    user = Las.Users.get_and_auth_user(email, password)
    if user do
      conn
      |> put_session(:user_id, user.id)
      |> put_session(:current_login_user, user)
      |> put_flash(:info, "Welcome back #{user.first_name}")
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
    |> put_flash(:info, "Succesfully logged out.")
    |> redirect(to: Routes.page_path(conn, :index))
  end
end
