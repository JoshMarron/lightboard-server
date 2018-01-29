defmodule LightboardServer.SerialCommunicator do
    use GenServer
    alias Nerves.UART, as: UART
    require Logger

    def start_link([]) do
        GenServer.start_link(__MODULE__, [], name: :serialiser)
    end

    def send_grid() do
        :ok
    end

    def send_word(word) do
        GenServer.call(:serialiser, {:send_word, word})
    end

    def change_colours do
        :ok
    end

    # Callbacks
    def init([]) do
        UART.start_link(name: :uart)
        case UART.open(:uart, "/dev/ttyACM0") do 
            :ok -> 
                Logger.info("Opened serial communication")
                {:ok, []}
            {:error, reason} ->
                Logger.error("Could not open serial communication: "<>inspect reason)
                {:stop, :serial_failure}
        end
    end

    def handle_call({:send_word, word}, from, state) do
        word = if(String.ends_with?(word, "\n"), do: word, else: word<>"\n")
        case UART.write(:uart, word) do
            :ok ->
                Logger.info("Sent word: "<>word)
                {:reply, {:ok, word}, []}
            {:error, reason} ->
                Logger.error("Could not send word over serial: "<> inspect reason)
                {:reply, {:error, :serial_failure}, []}
        end
    end
end