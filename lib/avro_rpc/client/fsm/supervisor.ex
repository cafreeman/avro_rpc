defmodule AvroRPC.Client.FSM.Supervisor do
  @moduledoc false
  use Supervisor

  def start_link(config) do
    Supervisor.start_link(__MODULE__, config, name: AvroRPC.Utils.via_tuple(config.name, :fsm))
  end

  @doc """
  Convert hostname from binary to charlist to make Erlang happy
  """
  def init(%{hostname: hostname} = config) when is_binary(hostname) do
    config
    |> Map.update!(:hostname, &to_charlist(&1))
    |> init
  end

  @doc """
  Actually start the FSM
  """
  def init(%{hostname: hostname, port: port, protocol: protocol_path, name: name}) do
    protocol = :eavro_rpc_proto.parse_protocol_file(protocol_path)

    children = [
      worker(:gen_fsm, [AvroRPC.Utils.via_tuple(name, :eavro_rpc_fsm), :eavro_rpc_fsm, [hostname, port, protocol], []]),
    ]

    opts = [strategy: :one_for_one]

    supervise(children, opts)
  end
end
