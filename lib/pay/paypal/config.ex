defmodule Pay.Paypal.Config do

  @api_url "https://api.paypal.com/v1"
  @sand_box_url "https://api.sandbox.paypal.com/v1"

  def url do
    case Application.get_env(:pay, :paypal)[:env] do
      :sandbox -> @sand_box_url
      _ -> @api_url
    end
  end

end
