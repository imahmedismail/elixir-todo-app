defmodule ElixirTodoApp.TeslaClient do
  use Tesla

  def get_request(url) do
    {:ok, response} = Tesla.get(url)
    response
  end
end
