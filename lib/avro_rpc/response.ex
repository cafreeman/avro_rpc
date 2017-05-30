defmodule AvroRPC.Response do
  def format(response) do
    try do
      convert(response)
    catch
      {:error, error} -> {:error, error}
    else
      converted_response ->
        {:ok, converted_response}
    end
  end

  defp convert({{:avro_array, {:avro_record, _name, _fields} = record_def}, [values]}) do
    do_convert_array(record_def, values)
  end

  defp convert({{:array, %ExAvro.Record{} = record_def}, [values]}) do
    do_convert_array(record_def, values)
  end

  defp convert({{:avro_array, item_type}, values}) do
    do_convert_array(item_type, values)
  end

  defp convert({{:array, item_type}, values}) do
    do_convert_array(item_type, values)
  end

  defp convert({{:avro_record, _name, fields}, values}) when length(fields) != length(values) do
    throw({:error, {:invalid_length, "The number of fields do not match the number of values."}})
  end

  defp convert({{:avro_record, _name, fields}, values}), do: do_convert_record(fields, values)
  defp convert({%ExAvro.Record{fields: fields, name: _name}, values}), do: do_convert_record(fields, values)

  defp convert({:ok, response}), do: convert(response)
  defp convert({_type, value}), do: convert(value)
  defp convert(value), do: value

  defp do_convert_array(item_type, values) do
    Enum.map(values, &convert({item_type, &1}))
  end

  defp do_convert_record(fields, values) do
    fields
    |> convert_field_list_to_keys
    |> Enum.zip(values)
    |> Map.new
  end

  defp convert_field_list_to_keys([{_, _} | _] = fields), do: Keyword.keys(fields)

  defp convert_field_list_to_keys([%ExAvro.Field{} | _] = fields) do
    Enum.map(fields, fn(field) ->
      convert_field_to_key(field)
    end)
  end

  defp convert_field_to_key(%ExAvro.Field{name: name, type: _type}), do: name

end
