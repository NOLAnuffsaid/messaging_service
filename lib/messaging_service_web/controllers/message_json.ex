defmodule MessagingServiceWeb.MessageJSON do
  alias MessagingService.Messages.Message

  @doc """
  Renders a list of messages.
  """
  def received_sms(%{message: message}) do
    data(message)
  end

  defp data(%Message{} = message) do
    %{
      id: message.id,
      from: message.from,
      to: message.to,
      body: message.body,
      attachments: message.attachments
    }
  end
end
