defmodule PhoneReader.Repo.Migrations.AddNumbersTable do
  use Ecto.Migration

  def change do
    create table(:numbers) do
      add :area_code, :string
      add :prefix,    :string
      add :suffix,    :string
      add :current,   :boolean
      timestamps
    end
    create index(:numbers, [:area_code, :current])
    create index(:numbers, [:prefix, :current])
  end
end
