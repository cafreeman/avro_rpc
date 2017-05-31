defmodule AvroRPC.Client.Supervisor do
  @moduledoc false
  use Supervisor

  def start_link(config) do
    Supervisor.start_link(__MODULE__, config, name: AvroRPC.Utils.via_tuple(config.name, :client_supervisor))
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
