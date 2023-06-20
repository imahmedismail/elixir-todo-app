defmodule ElixirTodoApp.HttpClient do
  use Tesla

  def get_request(url) do
    {:ok, response} = Tesla.get(url)
    response
  end

  def post_request(url, body) do
    {:ok, response} = Tesla.post(url, body)
    response
  end

  def put_request(url, body) do
    {:ok, response} = Tesla.put(url, body)
    response
  end

  def patch_request(url, body) do
    {:ok, response} = Tesla.patch(url, body)
    response
  end

  def delete_request(url) do
    {:ok, response} = Tesla.delete(url)
    response
  end
end
