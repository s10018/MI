class ChangeCameraTypeForMovies < ActiveRecord::Migration
  def up
    change_table :movies do |t|
      t.change :camera, :integer
    end	
  end

  def down
    change_table :movies do |t|
      t.change :camera, :string
    end	
  end
end







