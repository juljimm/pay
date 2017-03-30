defmodule Pay do
  use Application

  def start_link(type, args), do: start(type, args)
  def start(type,args) do
    case Application.get_env(:pay, :type) do
      :paypal -> Pay.Paypal.App.start(type, args)
      _ -> Pay.Paypal.App.start(type, args)
    end
  end
end
