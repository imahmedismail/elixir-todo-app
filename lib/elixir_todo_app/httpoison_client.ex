defmodule ElixirTodoApp.HttpoisonClient do
  use HTTPoison.Base

  def post_request(url, payload) do
    headers = [{"Content-Type", "application/json"}]
    body = Jason.encode!(payload)

    response = post(url, body, headers)

    case response do
      {:ok, %{status_code: 200, body: body}} ->
        body
    end
  end

  def patch_request(url, payload) do
    headers = [{"Content-Type", "application/json"}]
    body = Jason.encode!(payload)

    response = patch(url, body, headers)

    case response do
      {:ok, %{status_code: 200, body: body}} ->
        body
    end
  end
end
