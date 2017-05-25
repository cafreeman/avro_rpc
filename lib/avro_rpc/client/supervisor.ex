defmodule AvroRPC.Client.Supervisor do
  use Supervisor

  def start_link(config) do
    Supervisor.start_link(__MODULE__, config, name: __MODULE__)
  end

  def init(%{protocol: protocol} = config) do
    children = [
      supervisor(AvroRPC.Client.FSM.Supervisor, [config]),
      worker(AvroRPC.Client, [protocol])
    ]

    opts = [strategy: :rest_for_one]

    supervise(children, opts)
  end
end
