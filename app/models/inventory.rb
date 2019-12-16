class Inventory < ActiveRecord::Base
  establish_connection(:secondary)
  self.table_name = "Inventory"

end
