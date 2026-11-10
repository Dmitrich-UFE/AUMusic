class CreateReactions < ActiveRecord::Migration[8.1]
  def change
    create_table :reactions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :track, null: false, foreign_key: true
      t.string :kind, null: false # 'like' или 'dislike'


      t.timestamps
    end

    # Добавляем составной индекс уникальности на уровне СУБД PostgreSQL
    add_index :reactions, [:user_id, :track_id], unique: true
  end
end
