# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/PerceivedComplexity

module Enumerable
  def my_each
    return to_enum unless block_given?

    i = 0
    while i < size
      yield(to_a[i])
      i += 1
    end
    self
  end

  def my_each_with_index
    return to_enum unless block_given?

    i = 0
    while i < size
      yield(to_a[i], i)
      i += 1
    end
    self
  end

  def my_select
    return to_enum unless block_given?

    array = []
    my_each { |value| array << value if yield value }
    array
  end

  def my_all?(arg = nil)
    array = []
    if block_given?
      my_each { |value| array << value unless yield value }
    elsif arg.is_a? Regexp
      my_each { |value| array << value unless value.to_s =~ arg }
    elsif arg
      my_each { |value| array << value unless value == arg }
    else
      my_each { |value| array << value unless !value || value.nil? }
    end
    array.empty? ? true : false
  end

  def my_any?(arg = nil)
    if block_given?
      my_each { |value| return true if yield value }
    elsif arg.is_a? Regexp
      my_each { |value| return true if value.to_s =~ arg }
    elsif arg
      my_each { |value| return true if value == arg }
    else
      my_each { |value| return true if value }
    end
    false
  end

  def my_none?(arg = nil)
    if block_given?
      my_each { |value| return false if yield value }
    elsif arg.is_a? Regexp
      my_each { |value| return false if value.to_s =~ arg }
    elsif arg
      my_each { |value| return false if value == arg }
    else
      my_each { |value| return false if value }
    end
    true
  end

  def my_count(arg = nil)
    count = 0
    if block_given?
      my_each { |value| count += 1 if yield value }
    elsif arg
      my_each { |value| count += 1 if value == arg }
    else
      my_each { count += 1 }
    end
    count
  end

  def my_map(proc = nil)
    return to_enum unless block_given?

    array = []
    if proc
      my_each { |value| array.push(proc.call(value)) }
    else
      my_each { |value| array.push(yield(value)) }
    end
    array
  end

  def my_inject(*arg)
    arg[0].is_a?(Integer) ? initial = arg[0] : symbol = arg[0]
    if initial && !arg[1].is_a?(Integer)
      symbol = arg[1]
    elsif arg.nil?
      initial = self[0]
    end
    result = initial
    if symbol
      my_each { |value| result = result ? result.send(symbol, value) : value }
    else
      my_each { |value| result = result ? yield(result, value) : value }
    end
    result
  end

  def multiply_els(arr)
    arr.my_inject { |a, b| a * b }
  end
end

# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/PerceivedComplexity