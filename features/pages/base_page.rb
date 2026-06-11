# encoding: utf-8
class BasePage
  include Capybara::DSL
  include SupportObject

  def navigate_to(url)
    visit url
  end

  def has_text?(text)
    page.has_content?(text, wait: Capybara.default_max_wait_time)
  end

  def click_on_element(selector)
    find(selector).click
  end

  def fill_field(selector, value)
    find(selector).set(value)
  end

  def wait_for(selector, timeout: Capybara.default_max_wait_time)
    find(selector, wait: timeout)
  end
end
