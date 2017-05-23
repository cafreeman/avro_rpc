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

  test "converts a simple avro array" do
    IO.inspect @simple_array
    {:ok, converted_array} = AvroRPC.Response.convert(@simple_array)

    assert is_list(converted_array)
    assert length(converted_array) == 5
    assert converted_array == ["hi", "how", "are", "you", "?"]
  end

  @tag :skip
  test "converts an array of avro records" do
    {:ok, converted_array} = AvroRPC.Response.convert(@complex_array)

    assert [%{foo: "bar"}, %{foo: "bar"}] == converted_array
  end
end
