defmodule MessagingService.MessagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `MessagingService.Messages` context.
  """

  @doc """
  Generate an Email message.
  """
  def email_message_fixture(attrs \\ %{}) do
    {:ok, message} =
      attrs
      |> Enum.into(%{
        attachments: [],
        body: "some body",
        from: "b@another_email.com",
        timestamp: DateTime.utc_now(),
        to: "a@some_email.com"
      })
      |> MessagingService.Messages.create_email_message()

    message
  end

  @doc """
  Generate a SMS/MMS message.
  """
  def sms_message_fixture(attrs \\ %{}) do
    {:ok, message} =
      attrs
      |> Enum.into(%{
        attachments: [],
        body: "some body",
        from: "+15554505555",
        timestamp: DateTime.utc_now(),
        to: "+15045555555",
        type: Enum.random(["sms", "mms"])
      })
      |> MessagingService.Messages.create_sms_message()

    message
  end
end
