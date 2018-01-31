defmodule ColourHandler do
    require Logger

    def handleColours(colour_list) do
        if is_list(colour_list) and rem(length(colour_list), 3) == 0 do
            LightboardServer.SerialCommunicator.change_colours(colour_list)
        else
            {:error, "Invalid colour specification - must be a list of length multiple of 3"}
        end
    end

    def rainbowOn do
        LightboardServer.SerialCommunicator.rainbow_on
    end
end