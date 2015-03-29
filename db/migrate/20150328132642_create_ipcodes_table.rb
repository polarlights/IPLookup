class CreateIpcodesTable < ActiveRecord::Migration
  def change
    create_table :ipcodes, id: false do |t|
      t.integer :ip_start,    default: 0
      t.integer :ip_end,      default: 0
      t.integer :area_id,     default: 0
      t.string :other,        default: ""
    end

    add_index :ipcodes, :ip_start, unique: true
    add_index :ipcodes, :ip_end,   unique: true
    add_index :ipcodes, :area_id,  unique: true
  end
end
