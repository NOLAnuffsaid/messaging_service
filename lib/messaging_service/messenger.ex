defmodule MessagingService.Messenger do
  @callback send(map()) :: :ok | {:error, any()}

  def send(params), do: get_messenger().send(params)

  defp get_messenger,
    do:
      Application.get_env(
        :messaging_service,
        :messenger,
        MessagingService.Messenger.DefaultMessenger
      )
end
