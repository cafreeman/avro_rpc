defmodule AvroRPC.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    config = %{
      hostname: Application.get_env(:avro_rpc, :hostname),
      port: Application.get_env(:avro_rpc, :port),
      protocol: Application.get_env(:avro_rpc, :protocol)
    }

    children = [
      supervisor(AvroRPC.Client.Supervisor, [config])
    ]

    opts = [strategy: :one_for_one, name: AvroRPC.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
