defmodule MessagingService.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "messages" do
    field :body, :string
    field :to, :string
    field :from, :string
    field :attachments, {:array, :string}

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:from, :to, :body, :attachments])
    |> validate_required([:from, :to, :body])
  end
end
