defmodule P172.Repo.Migrations.AddReviews do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :reviews, :map
    end
  end
end
