class CreateInfos < ActiveRecord::Migration
  def change
    create_table :infos do |t|
      t.string :attr
      t.string :type
      t.string :value

      t.timestamps
    end
  end
end
