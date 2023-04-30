defmodule P172.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :model, :string
      add :price, :string

      timestamps()
    end
  end
end
