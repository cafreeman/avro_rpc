defmodule ConvertRecordTest do
  use ExUnit.Case

  @sample_record {
    {
      :avro_record,
      :Customer,
      [
        {"id", :string},
        {"phoneNumber", :string},
        {"data", :string},
        {"createdAt", :long},
        {"updatedAt", :long}
      ]
    },
    [
      "1234e967-dac2-4534-a023-ffadba5ea87e",
      "+14692882964",
      "{\"agent\":{\"phoneNumber\":\"+17378885895\"},\"facts\":{\"Work\":[\"Work From Home\"],\"Yard\":[\"No Yard\"],\"Effort\":[\"Investment\"],\"Social\":[\"Social In\"],\"Hobbies\":[\"Outdoor Hobbies\"],\"Parking\":[\"Parking\",\"No Parking\"],\"Privacy\":[\"Private\"],\"Shopping\":[\"Bigbox\"],\"Aesthetic\":[\"Modern\"],\"Neighborhood\":[],\"Type Of Home\":[\"Single Family\"],\"Walking Area\":[\"Schools\"],\"Mls Constraint\":[\"tx_actris\"],\"User Archetype\":[\"type 2\"],\"Price Constraint\":{},\"Bedroom Constraint\":{\"min\":1},\"Size Accommodation\":[\"Family\"],\"Bathroom Constraint\":{\"min\":1},\"Photo Count Constraint\":{\"min\":1},\"Preferred Neighborhoods\":[],\"Listing Status Constraint\":[\"Active\"]}}",
      1490649587612,
      1495070863382
    ]
  }

  @sample_invalid_record {
    {
      :avro_record,
      :Customer,
      [
        {"id", :string},
        {"phoneNumber", :string},
        {"data", :string},
        {"createdAt", :long},
        {"updatedAt", :long}
      ]
    },
    [
      "1234e967-dac2-4534-a023-ffadba5ea87e",
      "+14692882964",
      "{\"agent\":{\"phoneNumber\":\"+17378885895\"},\"facts\":{\"Work\":[\"Work From Home\"],\"Yard\":[\"No Yard\"],\"Effort\":[\"Investment\"],\"Social\":[\"Social In\"],\"Hobbies\":[\"Outdoor Hobbies\"],\"Parking\":[\"Parking\",\"No Parking\"],\"Privacy\":[\"Private\"],\"Shopping\":[\"Bigbox\"],\"Aesthetic\":[\"Modern\"],\"Neighborhood\":[],\"Type Of Home\":[\"Single Family\"],\"Walking Area\":[\"Schools\"],\"Mls Constraint\":[\"tx_actris\"],\"User Archetype\":[\"type 2\"],\"Price Constraint\":{},\"Bedroom Constraint\":{\"min\":1},\"Size Accommodation\":[\"Family\"],\"Bathroom Constraint\":{\"min\":1},\"Photo Count Constraint\":{\"min\":1},\"Preferred Neighborhoods\":[],\"Listing Status Constraint\":[\"Active\"]}}",
    ]
  }

  @sample_map %{
    "id" => "1234e967-dac2-4534-a023-ffadba5ea87e",
    "phoneNumber" => "+14692882964",
    "data" =>   "{\"agent\":{\"phoneNumber\":\"+17378885895\"},\"facts\":{\"Work\":[\"Work From Home\"],\"Yard\":[\"No Yard\"],\"Effort\":[\"Investment\"],\"Social\":[\"Social In\"],\"Hobbies\":[\"Outdoor Hobbies\"],\"Parking\":[\"Parking\",\"No Parking\"],\"Privacy\":[\"Private\"],\"Shopping\":[\"Bigbox\"],\"Aesthetic\":[\"Modern\"],\"Neighborhood\":[],\"Type Of Home\":[\"Single Family\"],\"Walking Area\":[\"Schools\"],\"Mls Constraint\":[\"tx_actris\"],\"User Archetype\":[\"type 2\"],\"Price Constraint\":{},\"Bedroom Constraint\":{\"min\":1},\"Size Accommodation\":[\"Family\"],\"Bathroom Constraint\":{\"min\":1},\"Photo Count Constraint\":{\"min\":1},\"Preferred Neighborhoods\":[],\"Listing Status Constraint\":[\"Active\"]}}",
    "createdAt" => 1490649587612,
    "updatedAt" => 1495070863382
  }

  @sample_record_struct {
    %ExAvro.Record{
      name: :Customer,
      fields: [
        %ExAvro.Field{
          name: "id",
          type: :string
        },
        %ExAvro.Field{
          name: "phoneNumber",
          type: :string
        },
        %ExAvro.Field{
          name: "data",
          type: :string
        },
        %ExAvro.Field{
          name: "createdAt",
          type: :long
        },
        %ExAvro.Field{
          name: "updatedAt",
          type: :long
        }
      ]
    },
    [
      "1234e967-dac2-4534-a023-ffadba5ea87e",
      "+14692882964",
      "{\"agent\":{\"phoneNumber\":\"+17378885895\"},\"facts\":{\"Work\":[\"Work From Home\"],\"Yard\":[\"No Yard\"],\"Effort\":[\"Investment\"],\"Social\":[\"Social In\"],\"Hobbies\":[\"Outdoor Hobbies\"],\"Parking\":[\"Parking\",\"No Parking\"],\"Privacy\":[\"Private\"],\"Shopping\":[\"Bigbox\"],\"Aesthetic\":[\"Modern\"],\"Neighborhood\":[],\"Type Of Home\":[\"Single Family\"],\"Walking Area\":[\"Schools\"],\"Mls Constraint\":[\"tx_actris\"],\"User Archetype\":[\"type 2\"],\"Price Constraint\":{},\"Bedroom Constraint\":{\"min\":1},\"Size Accommodation\":[\"Family\"],\"Bathroom Constraint\":{\"min\":1},\"Photo Count Constraint\":{\"min\":1},\"Preferred Neighborhoods\":[],\"Listing Status Constraint\":[\"Active\"]}}",
      1490649587612,
      1495070863382
    ]
  }

  @tag :only
  test "can convert a valid record to map" do
    {:ok, converted_record} = AvroRPC.Response.format(@sample_record)

    assert is_map(converted_record)
    assert converted_record |> Map.keys |> length == 5
    assert Map.equal?(@sample_map, converted_record)
  end

  test "returns :invalid_length error tuple on record with missing fields" do
    result = AvroRPC.Response.format(@sample_invalid_record)
    assert elem(result, 0) == :error
    assert {:invalid_length, "The number of fields do not match the number of values."} == elem(result, 1)
  end

  test "converts a record with an ExAvro.Record definition" do
    {:ok, converted_record} = AvroRPC.Response.format(@sample_record_struct)

    assert is_map(converted_record)
    assert converted_record |> Map.keys |> length == 5
    assert Map.equal?(@sample_map, converted_record)
  end

  @tag :skip
  test "returns :invalid_type tuple on non-record" do
    assert {:error, {:invalid_type, "You must pass an Erlang record."}} == AvroRPC.Response.format(%{hello: "world"})
  end
end
