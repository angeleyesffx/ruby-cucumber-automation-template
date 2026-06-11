# encoding: utf-8

Given("I am on the Books to Scrape homepage") do
  @books_home = BooksHomePage.new
  @books_home.navigate
  expect(@books_home.displayed?).to be true
end

Then("the homepage shows a list of books") do
  expect(@books_home.displayed?).to be true
end

Then("the book count on the homepage is greater than 0") do
  expect(@books_home.book_count).to be > 0
end

When("I navigate to the {string} category") do |category_key|
  @current_category_key = category_key
  category_name = datapool_read(category_key, "name")
  @books_home.navigate_to_category(category_name)
  @catalogue = BooksCataloguePage.new
end

Then("the catalogue page is displayed") do
  expect(@catalogue.displayed?).to be true
end

Then("the category heading matches the expected name for {string}") do |category_key|
  expected_name = datapool_read(category_key, "name")
  expect(@catalogue.page_heading.downcase).to include(expected_name.downcase),
    "Expected heading to include '#{expected_name}' but got '#{@catalogue.page_heading}'"
end

Then("the catalogue shows at least {int} book") do |min|
  min_from_pool = datapool_read(@current_category_key, "min_books")
  effective_min = [min, min_from_pool.to_i].max
  expect(@catalogue.book_count).to be >= effective_min
end

Then("some books have a next page available") do
  has_pagination = datapool_read(@current_category_key, "has_pagination")
  expect(@catalogue.has_next_page?).to be(has_pagination),
    "DataPool says pagination=#{has_pagination} but page.has_next_page?=#{@catalogue.has_next_page?}"
end
