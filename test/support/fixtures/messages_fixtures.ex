defmodule MessagingService.MessagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MessagingService.Messages` context.
  """

  @doc """
  Generate a message.
  """
  def message_fixture(attrs \\ %{}) do
    {:ok, message} =
      attrs
      |> Enum.into(%{
        attachments: ["option1", "option2"],
        body: "some body",
        from: "some from",
        to: "some to"
      })
      |> MessagingService.Messages.create_message()

    message
  end
end
