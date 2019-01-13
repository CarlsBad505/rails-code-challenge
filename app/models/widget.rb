class Widget < ApplicationRecord
  has_many :line_items
  accepts_nested_attributes_for :line_items

  def name_with_msrp
    "#{name} | $#{msrp}"
  end

end
