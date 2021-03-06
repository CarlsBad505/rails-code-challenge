# Description of Work
---

**1. That last developer - they did a number on the seeds, please refactor them!**
Yes, quite. First off, the string ‘randomization’ in the comments was misspelled :). The first thing I saw that was unnecessary was assigning each seed a variable. For example:
```
o1 = Order.create!()
```
We don't need to assign each instance of a seed, a variable such as `o1` because we don't use the variable. Secondly, instead of writing that line of code over and over again for each instance, we should instead use an iterator to spin up these seeds and keep it DRY. Next, the randomization is okay, but there's a better way to create random data without thinking so hard. I chose to use the `faker` gem to randomize data, its a popular gem with seed data and also has a wide range of data varieties. I also noticed we don't have seed data for widgets or line items, so following the same convention, I decided to create those as well. Here we have a scenario where it does make sense to use some variables. Here is a snippet below:
```
orders = Order.all
widgets = Widget.all
```
Using these variables, I can easily draw random associations when seeding line items using the `sample` method on the collection of orders or widgets. Finally, because a line item unit price appears to be the same as the widget msrp, we can associate the line item `unit_price` attribute directly to it's widget's `msrp`. In the real world, we might not be able to draw this conclusion (what if the line item unit price had a discount, or a promo code for example). But for the sake of the seed data, we'll assume a controlled environment.

**2. For some reason the index page will not render after the orders are seeded...**
By inspecting the `routes.rb` file, I noticed that we're using the rails convention `resources` which grants us access to rails route helpers. Awesome! The reason the index page won't render is because the route helper wasn't declared correctly. Specifically, here is the original line of code:
```
<li><%= link_to order.id, order_page(order) %></li>
```
Well, we know that route helpers end with the word *path*. So the problem with that line of code is the path helper is incorrect, instead of `order_page`, we want `order_path`. We can confirm this by going to the terminal and typing `rails routes` which will output the prefix for your path helper, if applicable. Also, when viewing the index page, we see an uncanny display of data. The cause of this is due to the line of code below:
```
<%= @orders.each do |order| %>
```
In ERB, we don't want to use the equal sign `<%=`, but instead we want just `<%`. The equal sign signifies that we should display that output in the view, but in this case we don't need to display the instance variable that we're looping through.

**3. Sort the orders into 2 categories on the index page - shipped and not shipped.  Sort the shipped orders by shipped date.**
In the `orders_controller.rb`, we can add two new instance variables to account for the two categories that we want to display, while simultaneously removing the old instance variable because its no longer necessary. The first instance variable looks like the following:
```
@orders_shipped = Order.where.not(shipped_at: nil).order(:shipped_at)
```
Lets break down this query in a SQL perspective to understand what active record is doing. We `SELECT` records `FROM` orders `WHERE` shipped_at `IS NOT NULL` and `ORDER BY` shipped_at. We don't need to explicitly call `ASC` on the `.order` query, because that is the default. Next, lets break down the second category:
```
@orders_not_shipped = Order.where(shipped_at: nil)
```
This is similar to the first query, lets break it down in a SQL perspective. We `SELECT` records `FROM` orders `WHERE` shipped_at `IS NULL`. Now by assigning two new instance variables to the two queries, we can easily use their respective collections to portray the data via the index page.

The view has some room for refactoring. We don't need to explicitly use `<html>`, `<body>`, `head` html selectors because rails already defines these in the `application.html.erb` file and propagates this information downward using the `<%= yield %>` statement in its body. Furthermore, the original code attempts to define the `title` as "Orders". This won't work because the `title` in `application.html.erb` is already defining it as a static string. Instead, we can build a helper (please see file `application_helper.rb`) that will dynamically change the title for us, by utilizing `provide` method. Finally, the structure of how the data is displayed is rather simple and not very visually appealing. I imported bootstrap and material design gems to help build a table in a grid system.

**4. Add an order entry screen that allows creating an order with multiple line items.**
We first create a button on the index page using a `link_to` rails helper that takes us to the `new` page where one can enter a new order via a nested form. The nested form is first established by allowing nested attributes in the order model as can be seen here:
```
accepts_nested_attributes_for :line_items
```
In the orders controller, we set up the the necessary instance variables for the view in both the `new` and `create` methods to prepare the form and the view. At the same time, we also want to follow rails conventions with strong params and nested attributes within like so:
```
private

def order_params
  params.require(:order).permit(:shipped_at, :expedite, line_items_attributes: [:id, :quantity, :unit_price, :widget_id, :_destroy])
end
```
In the form itself, we can utilize `<%= f.fields_for :line_items do |li_f| %>` as a nested form for line_items. The trick here is that the attribute `unit_price` should be the same thing as the widget's msrp. Doesn't make a lot of sense in the real world for a user to input their own unit_price. Theoretically, because a line_item also belongs to a widget, we can assume that the unit_price is the same thing as the associated widget's msrp in this example. We can achieve this with a little javascript snippet that I spun up in the page. The snippet uses some erb with javascript to assemble a hash of widgets and their relative msrps:
```
const widgets = {};
<% @widgets.each do |widget| %>
  widgets[<%= widget.id %>] = <%= widget.msrp %>;
<% end %>
```
Now I can populate a hidden field for the `unit_price` as soon as the user selects a widget from the dropdown. Furthermore, I used a gem called cocoon to help spin up new line items on the fly by onclick event. If a user needs to add more line items, they can do so on the fly. Subsequently, they can also delete the line item if they deem it is no longer necessary. Also in the javascript snippet, are `change` event functions that are listening and waiting to populate the additional new line items with a `unit_price`. On successful submission, they are taken to a `show` page for the order that was just created.

**5. The expedited flag on an order can't be disabled once it's been enabled. Find and fix the bug.**
The main problem here is that nothing is being instantiated or saved to the database when one attempts to flip the `expedite` attribute on or off via an Order. Upon calling the instance method `setting` on an order, the method builds a hash on the fly and determines the `presence` of a key. This is a problem because we're at the mercy of memory, which is not the best way to instantiate. Furthermore, the `presence` method will return nil if the object in question is either empty of falsey. Instead, we should save this attribute to the database, especially given it's potential importance in the real world. By doing so, we can still use the `expedited?` instance method to read the attribute (with a little refactoring) or just have it available on instances of an Order at all times. We accomplish this by generating a new migration, adding the expedite attribute to the schema as a boolean data type. Now we have access to this attribute in the form, when a user is attempting to create a new order.

**Specs**
I added a few more specs throughout including `POST` of a new order in the orders controller!
