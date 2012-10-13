class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :path
      t.string :camera
      t.string :date

      t.timestamps
    end
  end
end
