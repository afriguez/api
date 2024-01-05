defmodule ApiTest.Router do
  use ExUnit.Case, async: true
  use Plug.Test

  @opts Api.Router.init([])

  describe "Main Router" do
    test "Success when requesting /" do
      conn = conn(:get, "/")

      conn = Api.Router.call(conn, @opts)
      body = Poison.decode!(conn.resp_body)

      assert conn.state == :sent
      assert conn.status == 200
      assert body["success"]
    end
  end

  describe "Games Router" do
    test "Success when requesting a cover" do
      conn = conn(:get, "/v1/games/cover/genshin%20impact")

      conn = Api.Router.call(conn, @opts)
      body = Poison.decode!(conn.resp_body)

      assert conn.state == :sent
      assert conn.status == 200
      assert body["success"]
    end

    test "Success when requesting a thumbnail" do
      conn = conn(:get, "/v1/games/thumbnail/genshin%20impact")

      conn = Api.Router.call(conn, @opts)
      body = Poison.decode!(conn.resp_body)

      assert conn.state == :sent
      assert conn.status == 200
      assert body["success"]
    end

    test "Failure when requesting a cover" do
      conn = conn(:get, "/v1/games/cover/genshinimpact")

      conn = Api.Router.call(conn, @opts)
      body = Poison.decode!(conn.resp_body)

      assert conn.state == :sent
      assert conn.status == 404
      assert body["success"] == false
    end
  end
end
