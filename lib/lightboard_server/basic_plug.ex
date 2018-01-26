defmodule LightboardServer.BasicPlug do
    import Plug.Conn

    def init(options) do
        options
    end

    def call(conn, _opts) do
        conn = put_resp_content_type(conn, "text/plain")
        conn = send_resp(conn, 200, "Hello World!\n")
    end
end