defmodule Pay.Paypal.Experience do
  @derive [Poison.Encoder]
  defstruct id: nil, name: nil, temporary: nil, presentation: nil, input_fields: nil, flow_config: nil
end

defimpl Pay.Experience, for: Pay.Paypal.Experience do

  def create(experience) do
    Task.async(fn -> Pay.Paypal.Utils.post("/payment-experience/web-profiles", experience) end)
  end

end
