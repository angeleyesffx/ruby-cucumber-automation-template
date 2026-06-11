# encoding: utf-8
require "yaml"

# Loads all YAML files under features/support/data/ into a single frozen hash.
# Raises on duplicate top-level keys across files to prevent silent data shadowing.
DATA_ACCESS = Dir[File.join(__dir__, "data", "**", "*.yml")]
  .each_with_object({}) do |file, hash|
    entries = YAML.safe_load(File.read(file)) || {}
    entries.each do |key, value|
      sym = key.to_s.to_sym
      if hash.key?(sym)
        raise "DataPool collision: key '#{key}' defined in multiple YAML files. " \
              "Use unique top-level keys across all files in features/support/data/"
      end
      hash[sym] = value
    end
  end
  .freeze
