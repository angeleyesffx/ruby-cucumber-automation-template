# encoding: utf-8
require "dotenv"
Dotenv.load  # loads .env from cwd (project root when invoked via bundle exec)

require "capybara/cucumber"
require "capybara/rspec"
require "selenium-webdriver"
require "yaml"
require "json"

# Load support modules before page objects (order matters for include SupportObject in BasePage)
require_relative "modules/support_object"

# Load all page objects
Dir[File.join(__dir__, "..", "pages", "**", "*.rb")].sort.each { |f| require f }

ENV["TEST_ENV"] ||= "homolog"
HEADLESS = ENV.fetch("HEADLESS", "false") == "true"

config = YAML.load_file(File.join(__dir__, "config.yml"))
BASE_URL = config.dig(ENV["TEST_ENV"], "url") || raise("Missing url for env: #{ENV['TEST_ENV']}")

Capybara.register_driver :chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument("--window-size=1920,1080")
  options.add_argument("--disable-dev-shm-usage")
  options.add_argument("--no-sandbox")
  options.add_argument("--disable-blink-features=AutomationControlled")

  if HEADLESS
    options.add_argument("--headless=new")
    options.add_argument("--disable-gpu")
  end

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.default_driver     = :chrome
Capybara.javascript_driver  = :chrome
Capybara.default_max_wait_time = 20

# Make SupportObject utilities (datapool_read, generators, etc.) available in step definitions
World(SupportObject)
