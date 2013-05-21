class RemoveCorrectFromQuestions < ActiveRecord::Migration
  def up
    remove_column :questions, :correct
  end

  def down
    add_column :questions, :correct, :boolean
  end
end
