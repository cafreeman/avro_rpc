# For testing with local avro server

# {:ok, pid} = AvroRPC.Client.connect("localhost", 9015, "./test/data/avro.json")
#
# protocol = ExAvro.parse_protocol_file("./test/data/avro.json")
#
# answer = AvroRPC.Client.call(pid, :helloWorld, ["Chris"])

# Customer Profile

{:ok, pid} = AvroRPC.Client.connect("localhost", 9000, "./test/data/customer_profile.json")

protocol = ExAvro.parse_protocol_file("./test/data/customer_profile.json")

{:ok, answer} = AvroRPC.Client.call(pid, :customerByPhone, ["+14692882964"])
