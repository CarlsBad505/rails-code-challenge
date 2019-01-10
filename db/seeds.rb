require 'faker'

# Creating non-shipped orders.
5.times do
  Order.create!()
end

# PS: The word randomization was mispelled.
5.times do
  Order.create!(shipped_at: Faker::Time.between(DateTime.now - 1, DateTime.now))
end

5.times do
 Widget.create!(
   name: Faker::Lorem.word,
   msrp: Faker::Number.number(2)
 )
end

orders = Order.all
widgets = Widget.all

20.times do
  widget = widgets.sample
  LineItem.create!(
    order: orders.sample,
    widget: widget,
    quantity: Faker::Number.number(1),
    unit_price: widget.msrp
  )
end

puts "-"*50
puts "Seeding Finished"
puts "#{Order.count} orders created"
puts "#{Widget.count} widgets created"
puts "#{LineItem.count} line items created"
puts "-"*50
