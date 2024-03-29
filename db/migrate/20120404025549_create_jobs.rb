class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :name
      t.text :description
      t.boolean :active, :default => true

      t.timestamps
    end
  end
end
