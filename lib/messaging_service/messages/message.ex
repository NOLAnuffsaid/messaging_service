defmodule MessagingService.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "messages" do
    field :attachments, {:array, :string}
    field :body, :string
    field :from, :string
    field :xillio_id, :string
    field :timestamp, :utc_datetime
    field :to, :string
    field :type, Ecto.Enum, values: [:sms, :mms]

    timestamps(type: :utc_datetime)
  end

  def email_changeset(message, attrs) do
    message
    |> cast(attrs, [:from, :to, :body, :attachments, :timestamp, :xillio_id])
    |> validate_required([:from, :to, :body, :attachments, :xillio_id])
    |> validate_format(:from, ~r/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/)
    |> validate_format(:to, ~r/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/)
  end

  def sms_changeset(message, attrs) do
    message
    |> cast(attrs, [:from, :to, :body, :attachments, :timestamp, :type, :xillio_id])
    |> validate_required([:from, :to, :body, :xillio_id])
    |> validate_format(:from, ~r/^\+1\d{10}$/)
    |> validate_format(:to, ~r/^\+1\d{10}$/)
    |> validate_change(:type, &validate_sms_attachments(&1, &2, attrs))
  end

  def where_from_and_to(query \\ __MODULE__, from, to) do
    query
    |> where([m], m.from == ^from and m.to == ^to)
    |> or_where([m], m.from == ^to and m.to == ^from)
  end

  defp validate_sms_attachments(_, :sms, %{"attachments" => attachments})
       when not is_nil(attachments) do
    [type: "message cannot have attachments"]
  end

  defp validate_sms_attachments(_, _, _) do
    []
  end
end
