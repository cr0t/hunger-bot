class SimpleResponder < BaseResponder
  def initialize(response_text)
    @response_text = response_text
  end

  def response
    {text: @response_text}
  end
end
