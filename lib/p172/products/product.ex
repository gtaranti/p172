defmodule P172.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :model, :string
    field :price, :string

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:model, :price])
    |> validate_required([:model, :price])
  end
end
