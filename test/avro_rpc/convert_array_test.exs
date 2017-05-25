defmodule ConvertArrayTest do
  use ExUnit.Case

  @simple_array {
    {
      :avro_array,
      :string
    },
    [
      "hi",
      "how",
      "are",
      "you",
      "?"
    ]
  }

  @complex_array {
    {
      :avro_array,
      {
        :avro_record,
        :Custom,
        [{"foo", :string}]
      }
    },
    [
      [
        ["bar"],
        ["bar"]
      ]
    ]
  }

  @complex_array_with_struct {
    {
      :array,
      %ExAvro.Record{
        name: :Custom,
        fields: [
          %ExAvro.Field{
            name: "foo",
            type: :string
          },
        ]
      }
    },
    [
      [
        ["bar"],
        ["bar"]
      ]
    ]
  }

  @invalid_complex_array {
    {
      :avro_array,
      {
        :avro_record,
        :Custom,
        [{"foo", :string}, {"bar", :string}]
      }
    },
    [
      [
        ["bar"],
        ["bar"]
      ]
    ]
  }

  test "converts a simple avro array" do
    {:ok, converted_array} = AvroRPC.Response.format(@simple_array)

    assert is_list(converted_array)
    assert length(converted_array) == 5
    assert converted_array == ["hi", "how", "are", "you", "?"]
  end

  @tag :only
  test "converts an array of avro records" do
    {:ok, converted_array} = AvroRPC.Response.format(@complex_array)
    assert [%{"foo" => "bar"}, %{"foo" => "bar"}] == converted_array
  end

  test "converts an array of avro records with struct definitions" do
    {:ok, converted_array} = AvroRPC.Response.format(@complex_array_with_struct)

    assert [%{"foo" => "bar"}, %{"foo" => "bar"}] == converted_array
  end

  test "throws :invalid_length record error in invalid avro record array" do
    result = AvroRPC.Response.format(@invalid_complex_array)
    assert elem(result, 0) == :error
    assert {:invalid_length, "The number of fields do not match the number of values."} == elem(result, 1)
  end
end
