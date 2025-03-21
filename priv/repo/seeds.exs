# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     MessagingService.Repo.insert!(%MessagingService.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
Faker.start()

alias MessagingService.Messages.Message
alias MessagingService.Repo

for _ <- 5..50 do
  type = Enum.random(["sms", "mms"])
  from = "+1#{Faker.Util.format("%10d")}"
  to = "+1#{Faker.Util.format("%10d")}"
  provider = Faker.Internet.slug()

  for _ <- 5..15 do
    [from, to] = Enum.shuffle([from, to])

    params = %{
      "from" => from,
      "to" => to,
      "type" => type,
      "body" => Faker.Lorem.sentence(),
      "xillio_id" => provider,
      "attachments" => if(type == "mms", do: [Faker.Internet.image_url()], else: nil),
      "timestamp" => Faker.DateTime.between(~N[2016-12-20 00:00:00], ~N[2025-02-25 00:00:00])
    }

    %Message{}
    |> Message.sms_changeset(params)
    |> Repo.insert!()
  end
end

for _ <- 5..50 do
  from = Faker.Internet.email()
  to = Faker.Internet.email()
  provider = Faker.Internet.slug()

  for _ <- 3..8 do
    [from, to] = Enum.shuffle([from, to])

    params = %{
      "from" => from,
      "to" => to,
      "body" => Enum.join(Faker.Lorem.sentences(3), " "),
      "xillio_id" => provider,
      "attachments" => Enum.random([[], [Faker.Internet.image_url()]]),
      "timestamp" => Faker.DateTime.between(~N[2016-12-20 00:00:00], ~N[2025-02-25 00:00:00])
    }

    %Message{}
    |> Message.email_changeset(params)
    |> Repo.insert!()
  end
end
