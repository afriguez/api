defmodule Api.Util do
  import Plug.Conn

  def respond(conn, {:ok, data}) do
    data = Poison.encode!(%{success: true, data: data})
    conn |> send_resp(200, data)
  end

  def respond(conn, {:error, reason}) do
    data = Poison.encode!(%{success: false, error: reason})
    conn |> send_resp(404, data)
  end
end
