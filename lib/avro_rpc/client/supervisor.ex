defmodule AvroRPC.Client.Supervisor do
  use Supervisor

  def start_link(config) do
    # IO.puts "in avrorpc.client.supervisor"
    # IO.inspect config
    Supervisor.start_link(__MODULE__, config, name: {:via, Registry, {Registry.AvroRPC, {config.name, :client_supervisor}}})
    # Supervisor.start_link(__MODULE__, config)
  end

  def init(%{protocol: protocol} = config) do
    children = [
      supervisor(AvroRPC.Client.FSM.Supervisor, [config]),
      worker(AvroRPC.Client, [protocol, config.name])
    ]

    opts = [strategy: :rest_for_one]

    supervise(children, opts)
  end
end
