defmodule LightboardServerTest do
  use ExUnit.Case
  doctest LightboardServer

  test "greets the world" do
    assert LightboardServer.hello() == :world
  end
end
