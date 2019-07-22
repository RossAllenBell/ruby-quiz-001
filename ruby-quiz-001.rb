def main
  text = ARGV[0]

  puts "text: #{text}"

  cipher_format_val = cipher_format(text)
  puts "cipher_format: #{cipher_format_val}"

  solitaire_keystream_val = solitaire_keystream(text)
  puts "solitaire_keystream: #{solitaire_keystream_val}"

  chars_to_numbers_val = chars_to_numbers(cipher_format(text))
  puts "chars_to_numbers: #{chars_to_numbers_val}"

  solitaire_keystream_chars_to_numbers_val = chars_to_numbers(solitaire_keystream_val)
  puts "solitaire_keystream_chars_to_numbers: #{solitaire_keystream_chars_to_numbers_val}"

  add_numbers_val = add_numbers(chars_to_numbers_val, solitaire_keystream_chars_to_numbers_val)
  puts "add_numbers: #{add_numbers_val}"

  numbers_to_chars_val = numbers_to_chars(add_numbers_val)
  puts "numbers_to_chars: #{numbers_to_chars_val}"

  solitaire_keystream_val = solitaire_keystream(text)
  puts "solitaire_keystream: #{solitaire_keystream_val}"

  chars_to_numbers_val = chars_to_numbers(numbers_to_chars_val)
  puts "chars_to_numbers: #{chars_to_numbers_val}"

  solitaire_keystream_chars_to_numbers_val = chars_to_numbers(solitaire_keystream_val)
  puts "solitaire_keystream_chars_to_numbers: #{solitaire_keystream_chars_to_numbers_val}"

  subtract_numbers_val = subtract_numbers(chars_to_numbers_val, solitaire_keystream_chars_to_numbers_val)
  puts "subtract_numbers: #{subtract_numbers_val}"

  numbers_to_chars_val = numbers_to_chars(subtract_numbers_val)
  puts "numbers_to_chars: #{numbers_to_chars_val}"
end

def cipher_format(string)
  string.upcase.gsub(/[^A-Z]/, '').split('').each_slice(5).map(&:itself)
end

def solitaire_keystream(string)
  'DWJXH YRFDG TMSHP UURXJ'.split(' ').map{|s| s.split('')}
end

def chars_to_numbers(aoa)
  aoa.map do |a|
    a.map do |c|
      c.ord - 'A'.ord + 1
    end
  end
end

def add_numbers(aoa, keystream_aoa)
  aoa.map.with_index do |a, a_index|
    a.map.with_index do |c, c_index|
      (c + keystream_aoa[a_index][c_index]) % 26
    end
  end
end

def subtract_numbers(aoa, keystream_aoa)
  aoa.map.with_index do |a, a_index|
    a.map.with_index do |c, c_index|
      (c - keystream_aoa[a_index][c_index]) % 26
    end
  end
end

def numbers_to_chars(aoa)
  aoa.map do |a|
    a.map do |c|
      (c + 'A'.ord - 1).chr
    end
  end
end

main
