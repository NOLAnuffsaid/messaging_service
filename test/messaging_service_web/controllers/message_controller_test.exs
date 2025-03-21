defmodule MessagingServiceWeb.MessageControllerTest do
  use MessagingServiceWeb.ConnCase

  import ExUnit.CaptureLog

  # alias MessagingService.Messages.Message

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "send_message" do
    test "SMS - will log errors if phone numbers are invalid", %{conn: conn} do
      message_params = %{
        "from" => "+15558675309",
        "to" => "+105045555555",
        "type" => "sms",
        "xillio_id" => "provider-1",
        "body" => "test message",
        "attachments" => nil,
        "timestamp" => DateTime.utc_now()
      }

      {result, log} =
        with_log(fn ->
          conn
          |> post(~p"/api/messaging", message: message_params)
          |> json_response(422)
        end)

      require IEx
      IEx.pry()
      assert result == %{"errors" => %{"to" => ["has invalid format"]}}
      assert log =~ "Failed to send message!"
    end

    test "SMS - will log errors if either from/to phone number is missing", %{conn: conn} do
      message_params = %{
        "from" => nil,
        "to" => "+15045555555",
        "type" => "sms",
        "xillio_id" => "provider-1",
        "body" => "test message",
        "attachments" => nil,
        "timestamp" => DateTime.utc_now()
      }

      {result, log} =
        with_log(fn ->
          conn
          |> post(~p"/api/messaging", message: message_params)
          |> json_response(422)
        end)

      assert result == %{"errors" => %{"from" => ["can't be blank"]}}
      assert log =~ "Failed to send message!"
    end

    test "SMS - will log errors if there are attachments for sms messages", %{conn: conn} do
      message_params = %{
        "from" => "+15555045555",
        "to" => "+15045555555",
        "type" => "sms",
        "xillio_id" => "provider-1",
        "body" => "test message",
        "attachments" => ["image.png"],
        "timestamp" => DateTime.utc_now()
      }

      {result, log} =
        with_log(fn ->
          conn
          |> post(~p"/api/messaging", message: message_params)
          |> json_response(422)
        end)

      assert result == %{"errors" => %{"type" => ["message cannot have attachments"]}}
      assert log =~ "Failed to send message!"
    end

    test "SMS - will log success message after sending message", %{conn: conn} do
      Logger.configure(level: :info)

      message_params = %{
        "from" => "+13145550504",
        "to" => "+15045555555",
        "type" => "sms",
        "xillio_id" => "provider-1",
        "body" => "test message",
        "attachments" => nil,
        "timestamp" => DateTime.utc_now()
      }

      {result, log} =
        with_log(fn ->
          conn
          |> post(~p"/api/messaging", message: message_params)
          |> json_response(200)
        end)

      assert result["to"] == message_params["to"]
      assert result["from"] == message_params["from"]
      assert result["body"] == message_params["body"]
      assert result["attachments"] == message_params["attachments"]
      assert result["timestamp"] == format_datetime(message_params["timestamp"])

      assert log =~ "Message sent!"
    end

    test "MMS -  will log success message after sending message", %{conn: conn} do
      Logger.configure(level: :info)

      message_params = %{
        "from" => "+13145550504",
        "to" => "+15045555555",
        "type" => "mms",
        "xillio_id" => "provider1",
        "body" => "test message",
        "attachments" => ["image.png", "super_important.pdf"],
        "timestamp" => DateTime.utc_now()
      }

      {result, log} =
        with_log(fn ->
          conn
          |> post(~p"/api/messaging", message: message_params)
          |> json_response(200)
        end)

      assert result["to"] == message_params["to"]
      assert result["from"] == message_params["from"]
      assert result["body"] == message_params["body"]
      assert result["timestamp"] == format_datetime(message_params["timestamp"])

      for attachment <- result["attachments"] do
        assert attachment in message_params["attachments"]
      end

      require IEx
      IEx.pry()
      assert log =~ "Message sent!"
    end

    test "Email - will log errors if email address is missing", %{conn: conn} do
      message_params = %{
        "from" => "",
        "to" => "some@person.com",
        "xillio_id" => "provider-1",
        "body" => "<h1>Hello Friend!</h1>",
        "attachments" => [],
        "timestamp" => DateTime.utc_now()
      }

      {result, log} =
        with_log(fn ->
          conn
          |> post(~p"/api/messaging", message: message_params)
          |> json_response(422)
        end)

      assert result == %{"errors" => %{"from" => ["can't be blank"]}}
      assert log =~ "Failed to send message!"
    end

    test "Email - will log errors if email address invalid", %{conn: conn} do
      message_params = %{
        "from" => "original*!@some_weird_-company.!*com",
        "to" => "some@person.com",
        "xillio_id" => "provider-1",
        "body" => "<h1>Hello Friend!</h1>",
        "attachments" => [],
        "timestamp" => DateTime.utc_now()
      }

      {result, log} =
        with_log(fn ->
          conn
          |> post(~p"/api/messaging", message: message_params)
          |> json_response(422)
        end)

      assert result == %{"errors" => %{"from" => ["has invalid format"]}}
      assert log =~ "Failed to send message!"
    end

    test "Email - will log errors if email attachments are null", %{conn: conn} do
      message_params = %{
        "from" => "person@a.com",
        "to" => "some@person.com",
        "xillio_id" => "provider-1",
        "body" => "<h1>Hello Friend!</h1>",
        "attachments" => nil,
        "timestamp" => DateTime.utc_now()
      }

      {result, log} =
        with_log(fn ->
          conn
          |> post(~p"/api/messaging", message: message_params)
          |> json_response(422)
        end)

      assert result == %{"errors" => %{"attachments" => ["can't be blank"]}}
      assert log =~ "Failed to send message!"
    end

    test "Email - will log success message after sending email", %{conn: conn} do
      message_params = %{
        "from" => "person@a.com",
        "to" => "some@person.com",
        "xillio_id" => "provider-1",
        "body" => "<h1>Hello Friend!</h1>",
        "attachments" => [],
        "timestamp" => DateTime.utc_now()
      }

      {result, log} =
        with_log(fn ->
          conn
          |> post(~p"/api/messaging", message: message_params)
          |> json_response(200)
        end)

      assert result["to"] == message_params["to"]
      assert result["from"] == message_params["from"]
      assert result["body"] == message_params["body"]
      assert result["timestamp"] == format_datetime(message_params["timestamp"])

      for attachment <- result["attachments"] do
        assert attachment in message_params["attachments"]
      end

      assert log =~ "Message sent!"
    end
  end

  defp format_datetime(%DateTime{} = dt) do
    dt
    |> Map.merge(%{microsecond: {0, 0}})
    |> DateTime.to_iso8601()
  end
end
