defmodule FacebookClone.Repo.Migrations.EnablePgTrgmExstension do
  use Ecto.Migration

  def up do
    execute "CREATE extension if not exists pg_trgm;"
    execute "CREATE INDEX users_first_name_trgm_index ON users USING gin (first_name gin_trgm_ops);"
    execute "CREATE INDEX users_last_name_trgm_index ON users USING gin (last_name gin_trgm_ops);"
  end

  def down do
    execute "DROP INDEX users_first_name_trgm_index;"
    execute "DROP INDEX users_name_name_trgm_index;"
  end
end
