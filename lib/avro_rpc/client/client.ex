defmodule AvroRPC.Client do
  @moduledoc """
  Module for interacting with AvroRPC endpoints as a client.
  """
  use GenServer

  defmodule State do
    @moduledoc """
    Struct definition for the AvroRPC.Client GenServer state.
    """
    defstruct [
      protocol: nil,
      name: nil
    ]

    @type t :: %State{
      protocol: %ExAvro.Protocol{},
      name: atom
    }
  end

  @spec start_link(atom, atom) :: GenServer.on_start
  def start_link(protocol, name) do
    parsed_protocol = ExAvro.parse_protocol_file(protocol)
    GenServer.start_link(__MODULE__, {parsed_protocol, name}, name: AvroRPC.Utils.via_tuple(name, :client))
  end

  @spec init({%ExAvro.Protocol{}, atom}) :: {:ok, State.t}
  def init({parsed_protocol, name}) do
    {:ok, %State{protocol: parsed_protocol, name: name}}
  end

  @spec call(atom, atom, [...]) :: term
  def call(service_name, method, args) do
    GenServer.call(AvroRPC.Utils.via_tuple(service_name, :client), {:call, method, args})
  end

  ## Callbacks
  @spec handle_call({:call, atom(), [...]}, GenServer.from, %{}) :: {:reply, any, State.t}
  def handle_call({:call, method, args}, _from, state) do
    result =
      state.name
      |> AvroRPC.Utils.via_tuple(:eavro_rpc_fsm)
      |> :eavro_rpc_fsm.call(method, args)
      |> add_avro_type_to_response(method, state.protocol)
      |> AvroRPC.Response.format

    {:reply, result, state}
  end

  @spec add_avro_type_to_response({:ok, {any, any}}, any, any) :: {any, any}
  defp add_avro_type_to_response({:ok, {_, _} = response_with_schema_info}, _method, _protocol) do
    response_with_schema_info
  end

  @spec add_avro_type_to_response({:ok, any}, atom, %ExAvro.Protocol{}) :: {:ok, {tuple(), any}}
  defp add_avro_type_to_response({:ok, response}, method, protocol) do
    method
    |> find_message_protocol_by_name(protocol)
    |> add_return_type_to_response(response)
  end

  @spec find_message_protocol_by_name(atom, %ExAvro.Protocol{}) :: %ExAvro.Message{}
  defp find_message_protocol_by_name(method, protocol) do
    protocol
    |> Map.get(:messages)
    |> Enum.find(fn(msg) -> msg.name == Atom.to_string(method) end)
    |> Map.get(:return)
  end

  defp add_return_type_to_response(type_def, response), do: {:ok, {type_def, response}}
end
