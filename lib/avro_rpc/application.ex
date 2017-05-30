defmodule AvroRPC.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    service_config = Application.get_all_env(:avro_rpc) |> Keyword.get(:services)

    supervisor_children =
      service_config
      |> Enum.map(&supervisor(AvroRPC.Client.Supervisor, [&1], id: &1.name))

    children = [supervisor(Registry, [:unique, :avro_rpc_registry]) | supervisor_children ]

    opts = [strategy: :one_for_one, name: AvroRPC.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
