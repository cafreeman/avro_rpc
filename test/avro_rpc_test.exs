defmodule AvroRPCTest do
  use ExUnit.Case

  setup do
    {:ok, pid} = AvroRPC.Client.connect("localhost", 9000, "customer_profile.json")

    [pid: pid]
  end

  @tag :skip
  test "can connect", context do
    {:ok, user} = AvroRPC.Client.call(context[:pid], :customerByPhone, ["+14692882964"])
    IO.inspect user
  end
end
