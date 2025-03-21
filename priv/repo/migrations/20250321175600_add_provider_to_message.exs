defmodule MessagingService.Repo.Migrations.AddProviderToMessage do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      add :xillio_id, :string
    end
  end
end
