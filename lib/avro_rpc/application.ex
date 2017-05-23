defmodule AvroRPC.Application do
  use Application

  def start(_type, config) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(AvroRPC.Client.Supervisor, [config])
    ]

    opts = [strategy: :one_for_one, name: AvroRPC.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
