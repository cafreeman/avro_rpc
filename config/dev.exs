use Mix.Config

# config :avro_rpc,
#    hostname: "localhost",
#    port: 9015,
#    protocol: "./test/data/avro.json"

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
