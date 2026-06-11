# encoding: utf-8
module SupportObject
  # ─── DataPool ───────────────────────────────────────────────────────────────

  def datapool_read(data, key)
    dataset_key = data.to_s.to_sym
    dtp = DATA_ACCESS[dataset_key]
    raise "DataPool: dataset '#{data}' not found. Available: #{DATA_ACCESS.keys.join(', ')}" unless dtp

    case dtp
    when String then dtp
    when Hash
      # Use has_key? to correctly handle falsy values (false, 0, "")
      k = dtp.key?(key.to_s) ? key.to_s : key.to_sym
      raise "DataPool: field '#{key}' not found in '#{data}'. Fields: #{dtp.keys.join(', ')}" unless dtp.key?(k)
      dtp[k]
    else
      raise "DataPool: unexpected type #{dtp.class} for dataset '#{data}'"
    end
  end

  # ─── Element helpers ────────────────────────────────────────────────────────

  def element_exists?(type, element)
    page.has_selector?(type, element)
  end

  def get_random_amount_of_array(array, amount)
    array.dup.shuffle.first(amount)
  end

  # ─── Waits ──────────────────────────────────────────────────────────────────

  def wait_until_appears(type, name, timeout: Capybara.default_max_wait_time)
    find(type, name, wait: timeout, visible: true)
  end

  def wait_until_disappears(type, name, timeout: Capybara.default_max_wait_time)
    find(type, name, wait: timeout).assert_no_longer_visible
  rescue Capybara::ElementNotFound
    true
  end

  # ─── Test data generators ────────────────────────────────────────────────────

  def generate_string_code(length)
    (Array("A".."Z") + Array("a".."z")).sample(length).join
  end

  def generate_number_code(length)
    Array("0".."9").sample(length).join
  end

  def generate_alphanumeric_code(length)
    (Array("A".."Z") + Array("0".."9")).sample(length).join
  end

  def generate_mixed_code(char_count, num_count)
    generate_string_code(char_count) + generate_number_code(num_count)
  end
end
