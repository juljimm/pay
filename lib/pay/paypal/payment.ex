defmodule Pay.Paypal.Payment do
  @moduledoc """
  This module is responsible for handle all payment calls to paypal.
  The sctruct has the following keys:
  intent  string  Payment intent. Must be set to sale for immediate payment, authorize to authorize a payment for capture later, or order to create an order. Required.
  payer payer Source of the funds for this payment represented by a PayPal account or a credit card. Required.
  transactions  array of transaction objects  Transactional details including the amount and item details. Required.
  redirect_urls redirect_urls Set of redirect URLs you provide only for PayPal-based payments. Required for PayPal payments.
  update: used at the Payment.update protocol.
  """
  @derive [Poison.Encoder]
  defstruct intent: nil, experience_profile_id: nil, payer: nil, transactions: nil, id: nil, op: nil, update: nil, redirect_urls: nil
  @type p :: %Pay.Paypal.Payment{intent: String.t, payer: any, transactions: list(any), redirect_urls: any, id: integer, op: String.t, update: list(any)}

end

defimpl Pay.Payment, for: Pay.Paypal.Payment do

  @doc """
    Function to create a payment with Paypal. Receives a Dict with all information that is required by
    the Paypal API.

    Example of payment struct: %Paypal.Payment{"intent" => "sale", "payer" => %{"funding_instruments" => [%{"credit_card" => %{"billing_address" => %{"city" => "Saratoga", "country_code" => "US", "line1" => "111 First Street", "postal_code" => "95070", "state" => "CA"}, "cvv2" => "874", "expire_month" => 11, "expire_year" => 2018, "first_name" => "Betsy", "last_name" => "Buyer", "number" => "4417119669820331", "type" => "visa"}}], "payment_method" => "credit_card"}, "transactions" => [%{"amount" => %{"currency" => "USD", "details" => %{"shipping" => "0.03", "subtotal" => "7.41", "tax" => "0.03"}, "total" => "7.47"}, "description" => "This is the payment transaction description."}]}
    The information about the value of the keys are in https://developer.paypal.com/webapps/developer/docs/api/#create-a-payment

    Returns a Task.
  """
  def create_payment(payment) do
    Task.async(fn -> Pay.Paypal.Utils.post("/payments/payment", payment) end)
  end

  @doc """
  Function to get the status of the payment at Paypal. It returns the API JSON as a dict.
  It receives a Paypal.Payment struct with id.
  """
  def get_status(payment), do: Pay.Paypal.Utils.get("/payments/payment/" <> payment.id)

  @doc """
  Function to update payment fields. You have to pass in the update key a list with a HashDict with following keys:
  op  string  Patch operation to perform. Allowed values: add and replace.
  path  string  String containing a JSON-Pointer value that references a location within the target document (the target location) where the operation is performed.
  value object  New value to apply based on the operation. Allowed objects are amount object or shipping_address object.
  For more details see the Paypal Documentation: https://developer.paypal.com/webapps/developer/docs/api/#update-a-payment-resource

  It returns a PID for a Task.
  """
  def update_payment(payment) do
    Task.async(fn -> Pay.Paypal.Utils.post("/payments/payment/#{payment.id}", payment.update) end)
  end

  @doc """
  Use this call to get a list of payments in any state (created, approved, failed, etc.). The payments returned are the payments made to the merchant making the call.
  You should pass to this function just a empty Paypal.Payment like %Paypal.Payment{}
  """
  def get_payments(_payment), do: Pay.Paypal.Utils.get("/payments/payment/")

  @doc """
  Use this call to execute (complete) a PayPal payment that has been approved by the payer.
  You can optionally update transaction information when executing the payment by passing in one or more transactions.
  You have to set at least: %Paypal.Payment{id: PAYMENT_ID, payer: %{id: PAYER_ID}}

  """
  def execute_payment(payment) do
    Task.async(fn ->
      Pay.Paypal.Utils.post(
        "/payments/payment/#{payment.id}/execute",
        %{payer_id: payment.payer.id}
      )
    end)
  end

  @doc """
  Use this call to refund a completed payment.
  Provide the sale_id in the URI and an empty JSON payload for a full refund.
  For partial refunds, you can include an amount.
  payment muast be:
  $Paypal.Payment{id: PAYMENT_ID, transactions: [%{total: TOTAL, currency: CURRENCY}]}
  """
  def refund(_payment) do
  end

  # defp do_execute_payment(payment) do
  #   refund = Enum.first(payment.transactions)
  #   HTTPoison.post(Paypal.Config.url <> "/payments/sale/#{payment.id}/refund",
  #     Poison.encode!(%{total: refund.total, currency: refund.currency}),
  #     Paypal.Authentication.headers, timeout: :infinity, recv_timeout: :infinity)
  #   |> Paypal.Config.parse_response

  # end

end
