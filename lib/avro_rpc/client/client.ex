defmodule AvroRPC.Client do
  use GenServer

  defmodule State do
    defstruct [
      protocol: nil,
      name: nil
    ]
  end

  def start_link(protocol, name) do
    parsed_protocol = ExAvro.parse_protocol_file(protocol)
    GenServer.start_link(__MODULE__, [parsed_protocol, name], name: AvroRPC.Utils.via_tuple(name, :client))
  end

  def init([parsed_protocol, name]) do
    {:ok, %State{protocol: parsed_protocol, name: name}}
  end

  def call(service_name, method, args) do
    GenServer.call(AvroRPC.Utils.via_tuple(service_name, :client), {:call, method, args})
  end

  ## Callbacks
  def handle_call({:call, method, args}, _from, state) do
    result =
      :eavro_rpc_fsm.call(AvroRPC.Utils.via_tuple(state.name, :eavro_rpc_fsm), method, args)
      |> add_avro_type_to_response(method, state.protocol)
      |> AvroRPC.Response.format

    {:reply, result, state}
  end

  defp add_avro_type_to_response({:ok, {_, _} = response_with_schema_info}, _method, _protocol) do
    response_with_schema_info
  end

  defp add_avro_type_to_response({:ok, response}, method, protocol) do
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
