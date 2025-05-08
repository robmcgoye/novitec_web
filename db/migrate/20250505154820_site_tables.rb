class SiteTables < ActiveRecord::Migration[7.2]
  def change
    create_table :brands do |t|
      t.string :name

      t.timestamps
    end

    create_table :tiny_images do |t|
      t.string :file
      t.string :alt
      t.string :hint

      t.timestamps
    end

    create_table :engines do |t|
      t.string :name

      t.timestamps
    end

    create_table :pages do |t|
      t.string :name
      t.text :body

      t.timestamps
    end

    create_table :categories do |t|
      t.string :name

      t.timestamps
    end

    create_table :products do |t|
      t.references :category, null: false, foreign_key: true
      t.references :engine, null: false, foreign_key: true
      t.references :brand, null: false, foreign_key: true
      t.string :name
      t.string :model_number
      t.integer :price
      t.integer :stock
      t.text :description
      t.boolean :available

      t.timestamps
    end

    create_table :product_images do |t|
      t.references :product, null: false, foreign_key: true
      t.string :file

      t.timestamps
    end
  end
end
