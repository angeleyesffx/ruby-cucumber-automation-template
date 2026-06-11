# encoding: utf-8
require_relative "base_page"

class BooksCataloguePage < BasePage
  BOOK_ITEMS  = "article.product_pod"
  BOOK_TITLES = "article.product_pod h3 a"
  NEXT_BUTTON = "li.next a"
  PAGE_HEADER = "h1"
  RESULT_INFO = "form.form-horizontal strong:first-child"

  def displayed?
    page.has_selector?(BOOK_ITEMS, wait: 15)
  end

  def book_titles
    all(BOOK_TITLES, wait: 10).map { |el| el["title"] }
  end

  def book_count
    all(BOOK_ITEMS, wait: 10).count
  end

  def has_next_page?
    page.has_selector?(NEXT_BUTTON, wait: 3)
  end

  def page_heading
    find(PAGE_HEADER, wait: 10).text.strip
  end

  def titles_include?(text)
    book_titles.any? { |t| t.downcase.include?(text.downcase) }
  end
end
