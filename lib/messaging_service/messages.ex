defmodule MessagingService.Messages do
  @moduledoc """
  The Messages context.
  """

  import Ecto.Query, warn: false

  alias MessagingService.Messages.Message
  alias MessagingService.Messenger
  alias MessagingService.Repo

  @doc """
  Processes the incoming message and sends the message to its final destination
  """
  def process_incoming_message(%{"type" => _} = params) do
    with {:ok, message} <- create_sms_message(params) do
      Messenger.send(message)
    end
  end

  def process_incoming_message(params) do
    with {:ok, message} <- create_email_message(params) do
      Messenger.send(message)
    end
  end

  @doc """
  Returns all messages of a conversation
  """
  def get_conversation(%{"from" => from, "to" => to}) do
    Message
    |> Message.where_from_and_to(from, to)
    |> Repo.all()
  end

  defp create_email_message(attrs \\ %{}) do
    %Message{}
    |> Message.email_changeset(attrs)
    |> Repo.insert()
  end

  defp create_sms_message(attrs \\ %{}) do
    %Message{}
    |> Message.sms_changeset(attrs)
    |> Repo.insert()
  end
end
