class Dictionary
  attr_accessor :dictionary_list
  def initialize(min_word_length, max_word_length, dictionary_file)
    @dictionary_list = dictionary_loader(min_word_length, max_word_length,
      dictionary_file)
  end

  def dictionary_loader(min_word_length, max_word_length, dictionary_file)
    results = []
    File.open(dictionary_file).readlines.each do |line|
      results << line.strip.downcase if (min_word_length..max_word_length).
        include?(line.length)
    end
    results
  end
end

class Executioner
  attr_accessor :secret_word, :word_spaces, :guess_array
  def initialize(dictionary_list)
    @secret_word = secret_word_selector(dictionary_list)
    @word_spaces = word_spaces_loader
    @guess_array = []
  end

  def secret_word_selector(dictionary_list)
    dictionary_list.sample
  end

  def word_spaces_loader
    result = []
    secret_word.length.times {result << '_'}
    result
  end

  def letter_placer(letter)
    letter_found = false
    secret_word.split("").each_with_index do |ltr, index|
      if ltr == letter
        letter_found = true
        self.word_spaces[index] = ltr
      end
    end
    self.guess_array << letter
    letter_found
  end

  def word_spaces_finisher
    secret_word.split("").each_with_index do |ltr, index|
      self.word_spaces[index] = ltr
    end
  end
end

class GameFileManager
  def save_game(game_hash, file_name)
    File.open("#{file_name}.txt".gsub(/\s+/, ''), 'w') do |file|
      file.write(game_hash)
    end
  end

  def game_file_list
    #
  end
end