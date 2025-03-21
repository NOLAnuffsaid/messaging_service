defmodule MessagingServiceWeb.MessageController do
  use MessagingServiceWeb, :controller

  alias MessagingService.Messages

  require Logger

  action_fallback MessagingServiceWeb.FallbackController

  def send_message(conn, %{"message" => params} = message_data) do
    with :ok <- Messages.process_incoming_message(params) do
      Logger.info("Message sent!", message: message_data)
      render(conn, :message, message: message_data)
    else
      {:error, %{errors: errors}} = error ->
        Logger.error("Failed to send message!", message: message_data, errors: errors)
        error
    end
  end
end
