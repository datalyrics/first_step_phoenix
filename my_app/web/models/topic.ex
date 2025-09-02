defmodule MyApp.Topic do
  use MyApp.Web, :model

  # 1. my model schema: table topics, column title of type string
  schema "topics" do
    field :title, :string
  end

  # 2. define changeset
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:title])
    |> validate_required([:title])
  end

end
