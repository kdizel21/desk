class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.integer :group
      t.integer :question_group
      t.text :answer
      t.boolean :correct
      t.timestamps
    end
  end
end
