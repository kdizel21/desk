class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.integer :group
      t.text :question
      t.boolean :correct
      t.timestamps
    end
  end
end
