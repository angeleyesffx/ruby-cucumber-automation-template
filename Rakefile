require "cucumber/rake/task"
require "fileutils"

FileUtils.mkdir_p("reports/screenshots/failures")

Cucumber::Rake::Task.new(:test) do |t|
  t.cucumber_opts = "--profile default"
end

Cucumber::Rake::Task.new(:test_headless) do |t|
  t.cucumber_opts = "--profile headless"
end

Cucumber::Rake::Task.new(:test_ci) do |t|
  t.cucumber_opts = "--profile ci"
end

Cucumber::Rake::Task.new(:test_rerun) do |t|
  t.cucumber_opts = "--profile rerun"
end

Cucumber::Rake::Task.new(:test_browser) do |t|
  t.cucumber_opts = "--profile browser"
end

Cucumber::Rake::Task.new(:test_api) do |t|
  t.cucumber_opts = "--profile api"
end

namespace :marvel do
  desc "Introspect the Marvel App GraphQL schema and print all types (requires MARVEL_APP_TOKEN)"
  task :schema do
    require "dotenv"
    require "httparty"
    require "json"
    Dotenv.load(".env") if File.exist?(".env")

    token = ENV.fetch("MARVEL_APP_TOKEN") { abort "Set MARVEL_APP_TOKEN in .env first" }

    query = '{ __schema { queryType { name } types { name kind fields { name } } } }'
    res = HTTParty.post(
      "https://marvelapp.com/graphql",
      headers: { "Authorization" => "Bearer #{token}", "Content-Type" => "application/json" },
      body: { query: query }.to_json
    )

    body = JSON.parse(res.body)
    if body["errors"]
      puts "Error: #{body['errors'].map { |e| e['message'] }.join(', ')}"
    else
      types = body.dig("data", "__schema", "types")
                  .reject { |t| t["name"].start_with?("__") }
      types.each do |t|
        puts "\n#{t['kind']}: #{t['name']}"
        (t["fields"] || []).each { |f| puts "  - #{f['name']}" }
      end
    end
  end
end

task default: :test
