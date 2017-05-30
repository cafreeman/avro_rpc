defmodule AvroRPC.Application do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # config = %{
    #   hostname: Application.get_env(:avro_rpc, :hostname),
    #   port: Application.get_env(:avro_rpc, :port),
    #   protocol: Application.get_env(:avro_rpc, :protocol)
    # }

    service_config = Application.get_all_env(:avro_rpc) |> Keyword.get(:services)

    # Enum.each(service_config, fn(config) ->
    #   IO.inspect config
    # end)

    # children = Enum.map(service_config, &supervisor(AvroRPC.Client.Supervisor, [&1], id: &1.name))

    supervisor_children =
      service_config
      |> Enum.map(&supervisor(AvroRPC.Client.Supervisor, [&1], id: &1.name))

    children = [supervisor(Registry, [:unique, Registry.AvroRPC]) | supervisor_children ]

    # children = [
    #   supervisor(AvroRPC.Client.Supervisor, [config])
    # ]

    opts = [strategy: :one_for_one, name: AvroRPC.Supervisor]
    # opts = [strategy: :simple_one_for_one, name: AvroRPC.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # defp get_service_config(config) do
  #   %{
  #     hostname: Application.get_env(:avro_rpc, service_name, :hostname),
  #     port: Application.get_env(:avro_rpc, service_name, :port),
  #     protocol: Application.get_env(:avro_rpc, service_name, :protocol)
  #   }
  # end
end
