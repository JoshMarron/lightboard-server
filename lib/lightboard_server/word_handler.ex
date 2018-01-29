defmodule WordHandler do
    require Logger

    def sendWord(params) do
        Logger.info(params["word"])
        {:ok, pid} = Nerves.UART.start_link
        Logger.info(inspect pid)
        status = Nerves.UART.open(pid, "/dev/ttyACM0", speed: 9600)
        Logger.info(inspect status)
        status = Nerves.UART.write(pid, params["word"]<>"\n")
        Logger.info(inspect status)
        "Ok"
    end
end