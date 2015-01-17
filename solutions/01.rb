def series(sequence, index)
  case sequence
    when 'fibonacci' then fibonacci(index)
    when 'lucas' then lucas(index)
    else fibonacci(index) + lucas(index)
  end
end

def fibonacci(index)
  iterate_sequence(index, 1, 1)
end

def lucas(index)
  iterate_sequence(index, 1, 2)
end

def iterate_sequence(index, next_number, result)
  if index == 1
    result
  else
    iterate_sequence(index - 1, result + next_number, next_number)
  end
end