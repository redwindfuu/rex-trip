class EnablePgcrypto < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'pgcrypto'

    execute 'CREATE EXTENSION IF NOT EXISTS "uuid-ossp";'
  end
end
