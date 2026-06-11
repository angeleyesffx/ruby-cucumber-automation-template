# encoding: utf-8
require "fileutils"

SCREENSHOTS_DIR         = File.join(__dir__, "..", "..", "reports", "screenshots")
SCREENSHOTS_FAILED_DIR  = File.join(SCREENSHOTS_DIR, "failures")

FileUtils.mkdir_p(SCREENSHOTS_DIR)
FileUtils.mkdir_p(SCREENSHOTS_FAILED_DIR)

Before do |scenario|
  Capybara.reset_sessions!
  @scenario_name = scenario.name.gsub(/[^\w\s-]/, "").strip.gsub(/\s+/, "_")
end

After do |scenario|
  if scenario.failed?
    timestamp = Time.now.strftime("%Y-%m-%d_%H-%M-%S")
    filename  = "FAILED-#{@scenario_name}-#{timestamp}.png"
    path      = File.join(SCREENSHOTS_FAILED_DIR, filename)
    begin
      page.save_screenshot(path)
    rescue StandardError => e
      warn "Could not save screenshot: #{e.message}"
    end
  end
  Capybara.reset_sessions!
end
