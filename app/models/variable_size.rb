class VariableSize < ActiveRecord::Base
  establish_connection(:secondary)
  self.table_name = "Variables_Sizes"

end
