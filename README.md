# AvroRPC

`AvroRPC` is an Elixir library for making RPC calls using the [Avro protocol specification](http://avro.apache.org/docs/1.7.7/spec.html). Currently, `AvroRPC` wraps functionality from both the [eavro](https://github.com/SIfoxDevTeam/eavro) and [ex_avro](https://github.com/avvo/ex_avro) libraries and provides a unified client implementation for managing connections and calling methods across multiple `AvroRPC` services.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding both `avro_rpc` and `eavro` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:avro_rpc, "~> 0.1.0"},
    {:eavro, git: "https://github.com/sifoxdevteam/eavro.git", tag: "v0.0.3"}
  ]
end
```

You will also need to ensure that `avro_rpc` is started before your application:
```elixir
def application do
  [
    applications: [
      :avro_rpc
    ]
  ]
end
```

## Configuration

`AvroRPC` currently only provides an implementation for consuming AvroRPC endpoints as a client. When your application starts, `AvroRPC` will attempt to connect to each service specified in your application's configuration.

You can configure `AvroRPC` in your `mix.exs` file, like so:

```elixir
config :avro_rpc,
  services: [
    %{
      name: :service_1,
      hostname: "localhost",
      port: 9015,
      protocol: "./test/data/avro.json"
    },
    %{
      name: :service_2,
      hostname: "localhost",
      port: 9000,
      protocol: "./test/data/customer_profile.json"
    }
  ]
```

`AvroRPC` will open a connection for each item in the `services` list of your config.

Each individual element in the `services` list *must* be a `Map` containing the following fields:
- name (`atom`): The name of the service you're connecting to
- hostname (string): The hostname of the AvroRPC endpoint
- port (number): The port on which the AvroRPC endpoint receives TCP connections.
- protocol (string): The path to the Avro protocol definition file for the specific service.

## Usage

`AvroRPC` currently only exposes one public function: `AvroRPC.Client.call/3`, which is used to call a method on a specific service, and pass in a list of arguments to that method.

For example, if you have a service named `:test_server`, with a `hello` method, you'd call it like so:

```elixir
{:ok, response} = AvroRPC.Client.call(:test_server, :hello, ["world"])
```


Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/avro_rpc](https://hexdocs.pm/avro_rpc).
