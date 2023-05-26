defmodule P172.Products.Product do
  use Ecto.Schema
  import Ecto.Changeset

  alias P172.Products.Review

  schema "products" do
    field :model, :string
    field :price, :string
    embeds_many :reviews, Review, on_replace: :delete

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:model, :price])
    |> validate_required([:model, :price])
    |> cast_embed(:reviews,
      required: true,
      with: &P172.Products.Review.changeset/2,
      sort_param: :reviews_order,
      drop_param: :reviews_delete
    )
  end
end

defmodule P172.Products.Review do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  embedded_schema do
    field :author, :string
    field :stars, :integer
  end

  def changeset(review, attrs) do
    review
    |> cast(attrs, [:author, :stars])
    |> validate_required([:author, :stars])
  end
end
