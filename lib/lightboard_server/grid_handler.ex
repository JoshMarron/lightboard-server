defmodule GridHandler do
    require Logger

    @required_keys ["0", "1", "2", "3", "4", "5", "6", "7"]

    def handleGrid(params) do
        validate_grid(params["grid"])
    end

    defp validate_grid(grid) do
        Enum.all?(@required_keys, &(Map.has_key?(grid, &1) 
                                    and length(grid[&1]) == 8
                                    and validate_row(grid[&1])))
    end

    # Check the rows are all formed of valid colour codes
    defp validate_row(row) do
        Enum.all?(row, &(&1 >= 0 and &1 <= 65535))
    end
end