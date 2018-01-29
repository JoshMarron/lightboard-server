defmodule WordHandler do
    require Logger

    def sendWord(word) do
        if is_binary(word) and byte_size(word) < 100 do
            LightboardServer.SerialCommunicator.send_word(word)
        else
            {:error, "Invalid word"}
        end
    end
end