defmodule Pay.Paypal.Profile do
  @derive [Poison.Encoder]
  defstruct id: nil, name: nil, temporary: nil, presentation: nil, input_fields: nil, flow_config: nil
end

defimpl Pay.Profile, for: Pay.Paypal.Profile do

  def create(profile) do
    Task.async(fn -> Pay.Paypal.Utils.post("/payment-experience/web-profiles", profile) end)
  end

  def show(profile) do
    Task.async(fn -> Pay.Paypal.Utils.get("/payment-experience/web-profiles/#{profile.id}") end)
  end

  def list(_) do
    Task.async(fn -> Pay.Paypal.Utils.get("/payment-experience/web-profiles") end)
  end

  def update(profile) do
    Task.async(fn -> Pay.Paypal.Utils.put("/payment-experience/web-profiles/#{profile.id}", Map.drop(profile, [:id])) end)
  end

  def delete(profile) do
    Task.async(fn -> Pay.Paypal.Utils.delete("/payment-experience/web-profiles/#{profile.id}") end)
  end

end
