defmodule ElixirTodoAppWeb.Utils do
  def convert_list_of_maps(list) do
    Enum.map(list, &convert_map/1)
  end

  def convert_map(map) do
    Enum.reduce(map, %{}, fn {key, value}, acc ->
      acc |> Map.put(String.to_existing_atom(key), value)
    end)
  end
end
