defmodule LasWeb.Plugs.FetchSession do
  import Plug.Conn
   def init(args), do: args

   def call(conn, _opts) do
     if user = get_session(conn, :user) do
       token = Phoenix.Token.sign(conn, "user socket", user)
       assign(conn, :user_token, token)
     else
       assign(conn, :user_token, "")
     end
   end

end
