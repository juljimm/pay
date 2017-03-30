defmodule Pay.Paypal.Utils do

  def post(path, struct \\ %{}) do
    HTTPoison.post(
      Pay.Paypal.Config.url <> path,
      encode(struct),
      Pay.Paypal.Authentication.headers, timeout: :infinity, recv_timeout: :infinity
    )
    |> parse_response
  end

  def put(path, struct \\ %{}) do
    HTTPoison.put(
      Pay.Paypal.Config.url <> path,
      encode(struct),
      Pay.Paypal.Authentication.headers, timeout: :infinity, recv_timeout: :infinity
    )
  end

  def delete(path) do
    HTTPoison.delete(
      Pay.Paypal.Config.url <> path,
      Pay.Paypal.Authentication.headers, timeout: :infinity, recv_timeout: :infinity
    )
  end

  def get(path) do
    HTTPoison.get(
      Pay.Paypal.Config.url <> path,
      Pay.Paypal.Authentication.headers, timeout: :infinity, recv_timeout: :infinity
    )
    |> parse_response
  end

  #
  # Private
  #

  defp encode(struct) do
    Poison.encode!(struct) |> clean_request
  end

  defp clean_request(text) do
    text
    |> String.replace(~s("op":null,), "")
    |> String.replace(~s("update":null,), "")
  end

  def parse_response(response) do
    case response do
      {:ok, %HTTPoison.Response{status_code: 401, body: body, headers: _headers}} ->
        {:ok, response} = Poison.decode body
        {:auth_error, response}
      {:ok, %HTTPoison.Response{status_code: 204, headers: _headers}} -> {:ok, :noop}
      {:ok, %HTTPoison.Response{status_code: _, body: body, headers: _headers}} -> {:ok, Poison.decode! body}
      {:error, %HTTPoison.Error{reason: reason}} -> {:nok, reason}
    end
  end

end