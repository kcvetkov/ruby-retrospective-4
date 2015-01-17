class NumberSet
  include Enumerable

  def initialize()
    @numbers = []
  end

  def each
    return @numbers.to_enum(:each) unless block_given?
    @numbers.each { |n| yield n }
  end

  def <<(number)
    unless @numbers.include? number
      @numbers << number
    end
  end

  def size
    @numbers.size
  end

  def empty?
    @numbers.empty?
  end

  def [](filter)
    result = NumberSet.new
    @numbers.select { |number| filter.accepts? number }.each do |n|
      result << n
    end
    result
  end
end

class Filter
  def initialize(&block)
    @block = block
  end

  def accepts?(number)
    @block.(number)
  end

  def &(other)
    Filter.new { |number| accepts? number and other.accepts? number }
  end

  def |(other)
    Filter.new { |number| accepts? number or other.accepts? number }
  end
end

class TypeFilter < Filter
  def initialize(type)
    case type
    when :integer then super() { |number| number.integer? }
    when :real then super() { |n| n.is_a? Float or n.is_a? Rational }
    when :complex then super() { |number| number.is_a? Complex }
    end
  end
end

class SignFilter < Filter
  def initialize(sign)
    case sign
    when :positive then super() { |number| number > 0 }
    when :non_positive then super() { |number| number <= 0 }
    when :negative then super() { |number| number < 0 }
    when :non_negative then super() { |number| number >= 0 }
    end
  end
end