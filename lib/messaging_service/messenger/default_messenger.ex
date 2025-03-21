defmodule MessagingService.Messenger.DefaultMessenger do
  @behaviour MessagingService.Messenger

  require Logger

  @impl MessagingService.Messenger
  def send(message) do
    Logger.info("Sending Message: #{inspect(message)}...", message: message)
  end
end
