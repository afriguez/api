defmodule ApiTest.Router do
  use ExUnit.Case, async: true
  use Plug.Test

  @opts Api.Router.init([])

  test "Return OK" do
    conn = conn(:get, "/")

    conn = Api.Router.call(conn, @opts)

    assert conn.state == :sent
    assert conn.status == 200
    assert conn.resp_body == "OK"
  end
end
