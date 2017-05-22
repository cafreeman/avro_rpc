defmodule AvroRPC.Client do
  def connect(host, port, protocol_file) when is_binary(protocol_file) do
    protocol = parse_protocol_file(protocol_file)

    case :eavro_rpc_fsm.start_link(to_charlist(host), port, protocol) do
      {:ok, _pid} = result ->
        IO.puts "Opened an Avro RPC connection at #{host} on port #{port}"
        result
      {:error, err} ->
        IO.puts "There was an error connecting to the server"
        {:error, err}
    end
  end

  def call(pid, method, args) do
    :eavro_rpc_fsm.call(pid, method, args)
  end

  ## Private methods
  defp parse_protocol_file(path) do
    path
    |> File.read!
    |> :eavro_rpc_proto.parse_protocol
  end
end
