defmodule Pay.Paypal.Utils do

  def post(path, struct \\ %{}) do
    HTTPoison.post(
      Pay.Paypal.Config.url <> path,
      encode(struct),
      Pay.Paypal.Authentication.headers, timeout: :infinity, recv_timeout: :infinity
    )
    |> Pay.Paypal.Config.parse_response
  end

  def get(path) do
    HTTPoison.get(
      Pay.Paypal.Config.url <> path,
      Pay.Paypal.Authentication.headers, timeout: :infinity, recv_timeout: :infinity
    )
    |> Pay.Paypal.Config.parse_response
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

end