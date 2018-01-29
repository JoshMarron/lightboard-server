defmodule LightboardServer.Router do
    use Plug.Router
    require Logger

    plug(Plug.Parsers, parsers: [:urlencoded, :json], json_decoder: Jason)

    plug(:match)
    plug(:dispatch)

    post "/" do
        Logger.info(inspect conn.body_params)
        send_resp(conn, 200, "Hello World!\n")
    end

    post "/word" do
        Logger.info(inspect conn.body_params)
        result = WordHandler.sendWord(conn.body_params)
        send_resp(conn, 200, result)
    end

    post "/grid" do
        Logger.info(inspect conn.body_params)
        result = GridHandler.handleGrid(conn.body_params)
        if(result, do: send_resp(conn, 200, "Ok"), else: send_resp(conn, 200, "Error"))
    end

    match(_, do: send_resp(conn, 404, "Error\n"))
end