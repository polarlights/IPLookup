class CreateIpcodes < ActiveRecord::Migration
  def change
    create_table :ipcodes, id: false do |t|
      t.integer :ip_begin, index: true, unique: true, limit: 8
      t.integer :ip_end, index: true, unique: true, limit: 8
      t.string :area_code, index: true
      t.string :remark
    end
  end
end
