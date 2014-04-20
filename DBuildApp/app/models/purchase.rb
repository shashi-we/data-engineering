class Purchase < ActiveRecord::Base
	belongs_to :customer
  belongs_to :line_item
end
