defmodule AvroRPC.Client.FSM.Supervisor do
  use Supervisor

  def start_link(config) do
    Supervisor.start_link(__MODULE__, config, name: __MODULE__)
  end

  def init(%{hostname: hostname, port: port, protocol: protocol_path}) do
    protocol = :eavro_rpc_proto.parse_protocol_file(protocol_path)

    children = [
      worker(:gen_fsm, [{:local, :eavro_rpc_fsm}, :eavro_rpc_fsm, [hostname, port, protocol], []]),
    ]

    opts = [strategy: :one_for_one]

    supervise(children, opts)
  end
end
