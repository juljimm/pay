defprotocol Pay.Agreement do
  def create(agreement)
  def execute(token)
end
