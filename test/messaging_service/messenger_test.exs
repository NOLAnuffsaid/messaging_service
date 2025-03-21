defmodule MessagingService.MessengerTest do
  use ExUnit.Case

  import Mox

  alias MessagingService.Messenger

  require Logger

  setup :verify_on_exit!

  describe "send/1" do
    test "sends incoming messages to messenger api" do
      expect(MessengerMock, :send, fn _ ->
        Logger.info("Sending message")
        :ok
      end)

      assert :ok = Messenger.send(%{})
    end
  end
end

