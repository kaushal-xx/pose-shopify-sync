class VariableFulfillmentParameter < ActiveRecord::Base
  establish_connection(:secondary)
  self.table_name = "Variables_Fulfillment_Parameters"

end
