defmodule LightboardServer.SerialCommunicator do
    use GenServer
    alias Nerves.UART, as: UART
    require Logger

    defmodule SerialError do
        defexception message: "Serial communication error - consider restarting the Arduino and/or server"
    end

    def start_link([]) do
        GenServer.start_link(__MODULE__, [], name: :serialiser)
    end

    def send_grid(grid_list) do
        GenServer.cast(:serialiser, {:send_grid, grid_list})
    end

    def send_word(word) do
        GenServer.call(:serialiser, {:send_word, word})
    end

    def change_colours(colour_list) do
        GenServer.call(:serialiser, {:change_colours, colour_list})
    end

    # Callbacks
    def init([]) do
        UART.start_link(name: :uart)
        case UART.open(:uart, "/dev/ttyACM0", active: false) do 
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
        UART.write(:uart, 'W')
        case UART.write(:uart, word) do
            :ok ->
                Logger.info("Sent word: "<>word)
                {:reply, {:ok, word}, state}
            {:error, reason} ->
                Logger.error("Could not send word over serial: "<> inspect reason)
                {:reply, {:error, :serial_failure}, state}
        end
    end

    def handle_call({:change_colours, colour_list}, from, state) do
        UART.write(:uart, 'C')
        try do
            UART.write(:uart, <<div(length(colour_list), 3)::8>>)
            Enum.each(colour_list, fn(colour) -> 
                case UART.write(:uart, <<colour::8>>) do
                    :ok -> nil
                    {:error, reason} ->
                        Logger.error("Sending failed, restart the serialiser or Arduino: "<>inspect reason)
                        raise SerialError
                end
            end)
            {:reply, {:ok, length(colour_list)}, state}
        rescue
            e in SerialError ->
                {:reply, {:error, e}, state}
        end
    end

    def handle_cast({:send_grid, grid}, state) do
        UART.write(:uart, 'G')
        Enum.each(grid, fn(colour) ->
            case UART.write(:uart, <<colour::16>>) do
                :ok ->
                    nil
                {:error, reason} ->
                    Logger.error("Sending failed, restart the serialiser: "<>inspect reason)
                    raise("Serialising failed")
            end
            Process.sleep(400)
        end)
        {:noreply, state}
    end

end