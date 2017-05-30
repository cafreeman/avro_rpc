defmodule AvroRPC.Utils do
  def via_tuple(name, type) when is_atom(name) and is_atom(type) do
    {:via, Registry, {:avro_rpc_registry, {name, type}}}
  end

  def via_tuple(_, _) do
    throw(:error)
  end
end
