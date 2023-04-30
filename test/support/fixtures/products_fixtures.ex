defmodule P172.ProductsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `P172.Products` context.
  """

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        model: "some model",
        price: "some price"
      })
      |> P172.Products.create_product()

    product
  end
end
