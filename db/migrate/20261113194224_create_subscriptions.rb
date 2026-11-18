class CreateSubscriptions < ActiveRecord::Migration[8.1]
  def change
    create_table :subscriptions do |t|
      t.references :subscriber, null: false, foreign_key: { to_table: :users }
      t.references :author, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end

    add_index :subscriptions, [:subscriber_id, :author_id], unique: true
  end
end
