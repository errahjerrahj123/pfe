class AddConfigKeyToCountries < ActiveRecord::Migration[7.0]
  def change
    add_column :countries, :config_key, :string
  end
end
