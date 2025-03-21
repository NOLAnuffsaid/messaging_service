defmodule MessagingServiceWeb.MessageController do
  use MessagingServiceWeb, :controller

  alias MessagingService.Messages
  alias MessagingService.Messages.Message

  action_fallback MessagingServiceWeb.FallbackController

  def send_sms(conn, %{"message" => message_params}) do
    with {:ok, %Message{} = message} <- Messages.create_message(message_params) do
      render(conn, :received_sms, message: message)
    end
  end
end
