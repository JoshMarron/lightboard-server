defmodule LightboardServer.SerialCommunicator do
    use GenServer
    alias Nerves.UART, as: UART
    require Logger

    def start_link([]) do
        GenServer.start_link(__MODULE__, [], name: :serialiser)
    end

    def send_grid(grid_list) do
        GenServer.cast(:serialiser, {:send_grid, grid_list})
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

    def handle_cast({:send_grid, grid}, state) do
        UART.write(:uart, 'G')
        Enum.each(grid, fn(colour) ->
            UART.write(:uart, <<colour::16>>)
            Process.sleep(400)
        end)
        {:noreply, state}
    end


end