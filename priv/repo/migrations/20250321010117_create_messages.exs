defmodule MessagingService.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :attachments, {:array, :string}, null: true
      add :body, :string
      add :from, :string
      add :timestamp, :utc_datetime
      add :to, :string
      add :type, :string, null: true

      timestamps(type: :utc_datetime)
    end
  end
end
