defmodule WordHandler do
    require Logger

    def sendWord(params) do
        Logger.info(params["word"])
        "Ok"
    end
end