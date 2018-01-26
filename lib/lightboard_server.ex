defmodule LightboardServer do
    use Application
    require Logger
    @moduledoc """
    Documentation for LightboardServer.
    """
    def start(_type, _args) do
        children = [
            Plug.Adapters.Cowboy.child_spec(:http, LightboardServer.BasicPlug, [], port: 8080)
        ]

        Logger.info("Started application")

        Supervisor.start_link(children, strategy: :one_for_one)
    end
  
end
