defmodule GridHandler do
    require Logger

    @required_keys ["0", "1", "2", "3", "4", "5", "6", "7"]

    def handleGrid(grid) do
        validate_grid(grid)
        list_grid = flatten_grid(grid)
        Logger.info(inspect list_grid)
        LightboardServer.SerialCommunicator.send_grid(list_grid)
    end

    defp validate_grid(grid) do
        Enum.all?(@required_keys, &(Map.has_key?(grid, &1) 
                                    and length(grid[&1]) == 8
                                    and validate_row(grid[&1])))
    end

    defp flatten_grid(grid) do
        flatten_grid_accum(0, 7, grid, [])
    end

    defp flatten_grid_accum(next_index, last_index, grid, acc) do
        if next_index > last_index do
            acc
        else
            flatten_grid_accum(next_index + 1, last_index, grid, acc++grid[Integer.to_string(next_index)])
        end
    end

    # Check the rows are all formed of valid colour codes
    defp validate_row(row) do
        Enum.all?(row, &(&1 >= 0 and &1 <= 65535))
    end
end