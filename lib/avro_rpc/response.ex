defmodule AvroRPC.Response do
  def convert({{:avro_array, item_type}, values}) do
    values
    |> Enum.map(&AvroRPC.Response.convert({item_type, &1}))
  end

  def convert({{:avro_record, _name, fields}, values}) do
    cond do
      length(fields) == length(values) ->
        converted_record = Enum.zip(convert_field_list_to_keys(fields), values) |> Map.new
        {:ok, converted_record}

      true ->
        {:error, {:invalid_length, "The number of fields do not match the number of values."}}
    end
  end

  def convert({_type, value}) do
    convert(value)
  end

  def convert(value), do: value

  # def convert(_) do
  #   {:error, {:invalid_type, "You must pass an Erlang record."}}
  # end

  defp convert_field_list_to_keys(fields) do
    fields |> Keyword.keys
  end
end
