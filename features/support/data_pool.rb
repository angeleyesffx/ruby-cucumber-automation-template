# encoding: utf-8
require "yaml"

# Loads all YAML files under features/support/data/ into a single frozen hash.
# Keys are the top-level YAML keys converted to symbols (spaces preserved via gsub).
# Usage: DATA_ACCESS[:"mystery category"] or via SupportObject#datapool_read
DATA_ACCESS = Dir[File.join(__dir__, "data", "**", "*.yml")]
  .each_with_object({}) do |file, hash|
    entries = YAML.safe_load(File.read(file)) || {}
    entries.each { |k, v| hash[k.to_s.to_sym] = v }
  end
  .freeze
