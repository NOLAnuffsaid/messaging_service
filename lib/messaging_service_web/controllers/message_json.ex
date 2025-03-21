defmodule MessagingServiceWeb.MessageJSON do
  alias MessagingService.Messages.Message

  @doc """
  Renders a list of messages.
  """
  def message(%{message: message}) do
    data(message)
  end

  defp data(%{"message" => message}) do
    %{
      attachments: message["attachments"],
      body: message["body"],
      from: message["from"],
      timestamp: message["timestamp"],
      to: message["to"],
      xillio_id: message["xillio_id"]
    }
  end
end
