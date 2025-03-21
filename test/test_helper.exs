Mox.defmock(MessengerMock, for: MessagingService.Messenger)
Application.put_env(:messaging_service, :messenger, MessengerMock)

ExUnit.start()
Faker.start()
Ecto.Adapterf.SQL.Sandbox.mode(MessagingService.Repo, :manual)
