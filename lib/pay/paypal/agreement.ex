defmodule Pay.Paypal.Agreement do
  @derive [Poison.Encoder]
  defstruct id: nil, state: nil, name: nil, description: nil, start_date: nil, agreement_details: nil, payer: nil, plan: nil, shipping_address: nil
end

defimpl Pay.Agreement, for: [Pay.Paypal.Agreement, BitString] do

  def create(agreement) do
    Task.async(fn -> Pay.Paypal.Utils.post("/payments/billing-agreements", agreement) end)
  end

  def execute(token) do
    Task.async(fn -> Pay.Paypal.Utils.post("/payments/billing-agreements/#{token}/agreement-execute") end)
  end

end
