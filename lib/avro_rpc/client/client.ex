defmodule AvroRPC.Client do
  use GenServer

  defmodule State do
    defstruct [
      protocol: nil
    ]
  end

  def start_link(protocol) do
    parsed_protocol = ExAvro.parse_protocol_file(protocol)
    GenServer.start_link(__MODULE__, parsed_protocol, name: __MODULE__)
  end

  def init(parsed_protocol) do
    {:ok, %State{protocol: parsed_protocol}}
  end

  def call(method, args) do
    GenServer.call(__MODULE__, {:call, method, args})
  end

  ## Callbacks
  def handle_call({:call, method, args}, _from, state) do
    result =
      :eavro_rpc_fsm.call(:eavro_rpc_fsm, method, args)
      |> add_avro_type_to_response(method, state.protocol)
      |> AvroRPC.Response.format

    {:reply, result, state}
  end

  defp add_avro_type_to_response({:ok, {_, _} = response_with_schema_info}, _method, _protocol) do
    IO.puts "Assume we have schema info already"
    response_with_schema_info
  end

  defp add_avro_type_to_response({:ok, response}, method, protocol) do
    IO.puts "Need to look up schema info"
    find_message_protocol_by_name(method, protocol)
    |> add_return_type_to_response(response)
  end

  defp find_message_protocol_by_name(method, protocol) do
    protocol
    |> Map.get(:messages)
    |> Enum.find(fn(msg) -> msg.name == Atom.to_string(method) end)
    |> Map.get(:return)
  end

  defp add_return_type_to_response(type_def, response), do: {:ok, {type_def, response}}
end
