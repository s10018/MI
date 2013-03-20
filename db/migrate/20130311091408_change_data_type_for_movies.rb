class ChangeDataTypeForMovies < ActiveRecord::Migration
  def up
    change_table :movies do |t|
      t.change :date, :timestamp
    end	
  end

  def down
    change_table :movies do |t|
      t.change :date, :string
    end	
  end
end
