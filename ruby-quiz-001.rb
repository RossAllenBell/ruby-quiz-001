require 'pry'

def main
  text = ARGV[0]

  puts "text: #{text}"

  deck_val = deck_of_cards
  puts "deck: #{deck_val}"

  cipher_format_val = cipher_format(text)
  puts "cipher_format: #{cipher_format_val}"

  solitaire_keystream_val = solitaire_keystream(cipher_format_val, deck_val)
  puts "solitaire_keystream: #{solitaire_keystream_val}"

  chars_to_numbers_val = chars_to_numbers(cipher_format(text))
  puts "chars_to_numbers: #{chars_to_numbers_val}"

  solitaire_keystream_chars_to_numbers_val = chars_to_numbers(solitaire_keystream_val)
  puts "solitaire_keystream_chars_to_numbers: #{solitaire_keystream_chars_to_numbers_val}"

  add_numbers_val = add_numbers(chars_to_numbers_val, solitaire_keystream_chars_to_numbers_val)
  puts "add_numbers: #{add_numbers_val}"

  numbers_to_chars_val = numbers_to_chars(add_numbers_val)
  puts "numbers_to_chars: #{numbers_to_chars_val}"

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
  val = string.upcase.gsub(/[^A-Z]/, '').split('').each_slice(5).map(&:itself)
  while val.last.size < 5
    val.last << 'X'
  end
  return val
end

def solitaire_keystream(aoa, deck)
  deck_copy = deck.dup
  val = []
  aoa.each do |a|
    val << []
    while val.last.size < a.size
      top_num = deck_copy.first
      top_num = 53 if top_num > 53
      next_letter_num = deck_copy[top_num]
      if next_letter_num < 53
        val.last << number_to_char(next_letter_num)
      end

      deck_copy = move_card(deck_copy, 53, 1)
      deck_copy = move_card(deck_copy, 54, 2)

      deck_copy = triple_cut(deck_copy)

      deck_copy = count_cut(deck_copy)
    end
  end
  return val
end

def char_to_number(char)
  char.ord - 'A'.ord + 1
end

def chars_to_numbers(aoa)
  aoa.map do |a|
    a.map do |c|
      char_to_number(c)
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

def number_to_char(num)
  (((num - 1) % 26) + 'A'.ord).chr
end

def numbers_to_chars(aoa)
  aoa.map do |a|
    a.map do |n|
      number_to_char(n)
    end
  end
end

def deck_of_cards
  deck = (1..54).to_a
  puts "start deck: #{deck}"
  deck = deck.shuffle
  puts "shuffled deck: #{deck}"

  deck = move_card(deck, 53, 1)
  puts "first joker move: #{deck}"
  deck = move_card(deck, 54, 2)
  puts "second joker move: #{deck}"

  deck = triple_cut(deck)
  puts "triple cut: #{deck}"

  deck = count_cut(deck)
  puts "count cut: #{deck}"

  return deck
end

def move_card(deck, card, distance)
  index = deck.index(card)

  new_index = index + distance
  if new_index >= deck.size
    new_index = (new_index % deck.size) + 1
  end

  new_deck = deck.dup

  new_deck.delete_at(index)
  new_deck.insert(new_index, card)

  return new_deck
end

def triple_cut(deck)
  first_joker_index, second_joker_index = [deck.index(53), deck.index(54)].sort
  return deck.slice(second_joker_index + 1, (deck.size - second_joker_index) - 1) +
    deck.slice(first_joker_index, (second_joker_index - first_joker_index) + 1) +
    deck.slice(0, first_joker_index)
end

def count_cut(deck)
  cut_location = deck.last
  return deck.slice(cut_location, (deck.size - cut_location) - 1) +
    deck.slice(0, cut_location) +
    [deck.last]
end

main
