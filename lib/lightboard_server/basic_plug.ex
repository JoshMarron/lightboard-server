defmodule LightboardServer.BasicPlug do
    import Plug.Conn

    def init(options) do
        options
    end

    def call(conn, _opts) do
        conn = conn.put_resp_content_type("text/plain")
        conn.send_resp(200, "Hello World!\n")
    end
end