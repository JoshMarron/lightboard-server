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
        conn = put_resp_content_type(conn, "application/json")
        case WordHandler.sendWord(conn.body_params["word"]) do
            {:ok, word} -> send_resp(conn, 200, Jason.encode!(%{result: "success", word: word}))
            {:error, reason} -> send_resp(conn, 500, Jason.encode!(%{result: "error", reason: reason}))
        end
    end

    post "/grid" do
        Logger.info(inspect conn.body_params)
        result = GridHandler.handleGrid(conn.body_params)
        if(result, do: send_resp(conn, 200, "Ok"), else: send_resp(conn, 200, "Error"))
    end

    match(_, do: send_resp(conn, 404, "Error\n"))
end