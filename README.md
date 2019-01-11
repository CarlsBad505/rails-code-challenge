# README

## TODO

* Please utilize git and commit as you go!

- That last developer - they did a number on the seeds, please refactor them!
- For some reason the index page will not render after the orders are seeded...
- Sort the orders into 2 categories on the index page - shipped and not shipped.  Sort the shipped orders by shipped date.
- Add an order entry screen that allows creating an order with multiple line items.
- The expedited flag on an order can't be disabled once it's been enabled. Find and fix the bug.

* Bonus - Ascii art? (for Austin)
## Setup

```
bundle install
bundle exec rails db:create db:migrate db:seed
bundle exec rspec
```

## Submission
Send a link to your Fork of this code to [dev@pairin.com](mailto:dev@pairin.com) with any notes on what you did and why.

---

# Description of Work

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
