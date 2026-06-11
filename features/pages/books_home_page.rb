# encoding: utf-8
require_relative "base_page"

class BooksHomePage < BasePage
  BOOK_LIST    = "article.product_pod"
  CATEGORY_NAV = ".side_categories ul li a"
  SEARCH_FORM  = "form[action]"

  def navigate
    navigate_to BASE_URL
  end

  def displayed?
    page.has_selector?(BOOK_LIST, wait: 15)
  end

  def book_count
    all(BOOK_LIST, wait: 10).count
  end

  def categories
    all(CATEGORY_NAV, wait: 10).map(&:text).map(&:strip)
  end

  def navigate_to_category(name)
    cat_link = all(CATEGORY_NAV, wait: 10).find { |el| el.text.strip.downcase.include?(name.downcase) }
    raise "Category '#{name}' not found. Available: #{categories.join(', ')}" unless cat_link
    cat_link.click
  end
end
