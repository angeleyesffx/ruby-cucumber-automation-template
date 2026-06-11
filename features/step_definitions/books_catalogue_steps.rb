# encoding: utf-8

Given("I am on the Books to Scrape homepage") do
  @books_home = BooksHomePage.new
  @books_home.navigate
  expect(@books_home.displayed?).to be true
end

# ─── Homepage ──────────────────────────────────────────────────────────────────

When("I view the homepage catalogue") do
  # homepage already loaded via Background — this step makes Given→When→Then explicit
end

Then("the homepage shows a list of books") do
  expect(@books_home.displayed?).to be true
end

Then("the book count on the homepage is greater than 0") do
  expect(@books_home.book_count).to be > 0
end

# ─── Category navigation ───────────────────────────────────────────────────────

When("I navigate to the {string} category") do |category_key|
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

# ─── Pagination assertions — category key passed explicitly (no shared state) ──

Then("the {string} catalogue shows at least {int} book") do |category_key, min|
  min_from_pool = datapool_read(category_key, "min_books").to_i
  effective_min = [min, min_from_pool].max
  expect(@catalogue.book_count).to be >= effective_min,
    "Expected at least #{effective_min} books for '#{category_key}' but got #{@catalogue.book_count}"
end

Then("the {string} category has a next page") do |category_key|
  expected = datapool_read(category_key, "has_pagination")
  expect(expected).to be(true),
    "DataPool declares '#{category_key}' has no pagination — wrong step used"
  expect(@catalogue.has_next_page?).to be(true),
    "Expected a next-page link for '#{category_key}' but none was found"
end

Then("the {string} category has no next page") do |category_key|
  expected = datapool_read(category_key, "has_pagination")
  expect(expected).to be(false),
    "DataPool declares '#{category_key}' has pagination — wrong step used"
  expect(@catalogue.has_next_page?).to be(false),
    "Expected no next-page link for '#{category_key}' but one was found"
end
