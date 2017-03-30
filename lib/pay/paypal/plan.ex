defmodule Pay.Paypal.Plan do
  @derive [Poison.Encoder]
  defstruct id: nil, name: nil, description: nil, type: nil, payment_definitions: nil, merchant_preferences: nil
end

defimpl Pay.Plan, for: Pay.Paypal.Plan do

  def create(plan) do
    Task.async(fn -> Pay.Paypal.Utils.post("/payments/billing-plans", plan) end)
  end

  def update(plan) do
    Task.async(fn ->
      Pay.Paypal.Utils.post(
        "/payments/billing-plans/#{plan.id}",
        [%{path: "/", value: %{"state" => "ACTIVE"}, op: "replace"}]
      )
    end)
  end

end
