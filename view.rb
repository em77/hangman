module Display
  def self.word_spaces_printer(word_spaces)
    print "\n\n#{word_spaces.join(' ').upcase}\n\n"
  end

  def self.current_word_spaces(word_spaces, remaining_turns, guess_array)
    word_spaces_printer(word_spaces)
    print "Your guesses: #{guess_array.join(", ")}\n\n"
    print "#{remaining_turns} mistakes remaining\n\n"
  end

  def self.file_lister(list)
    puts
    list.each_with_index do |name, index|
      puts "#{index + 1}   #{name}"
    end
  end
end

module Prompt
  def self.load_or_new(choices_array)
    print "\n\nWould you like to start a new game or load a previous game?"
    decision(choices_array)
  end

  def self.playing_decision(choices_array)
    print "\n\nWhat would you like to do? You can guess a letter, attempt to"
    print "\nsolve the entire word, save your game to come back to later, or"
    print "\nexit the game without saving."
    decision(choices_array)
  end

  def self.decision(choices_array)
    print "\nEnter your decision (#{choices_array.join(", ")}): "
    gets.chomp.downcase
  end

  def self.word
    print "\n\nEnter what you believe the secret word to be: "
    gets.chomp.downcase
  end

  def self.letter
    print "\n\nEnter a letter (only one): "
    gets.chomp.downcase
  end

  def self.file_name
    print "\n\nPlease enter the name you would like to give the game file: "
    gets.chomp.downcase
  end

  def self.file_selector(file_list, choices_array)
    Display::file_lister(file_list)
    print "\n\nPlease enter the number of the game file you wish to load."
    decision(choices_array)
  end

  def self.game_over
    print "\n\nGame over! Would you like to play again? (yes/no): "
    gets.chomp.downcase
  end

  def self.play_again(choices_array)
    print "\n\nWould you like to play again?"
    decision(choices_array)
  end
end

module Message
  def self.welcome_rules
    print "\n\nWelcome to Hangman in Ruby!"
    puts "\n\nThe computer selects a random word that is symbolized by empty"
    puts "dashes, each dash corresponding to a letter of the word. The"
    puts "object of the game is to guess the word in as few turns as"
    puts "possible. Each turn, the player is given the option to guess a"
    puts "letter of the word, attempt to solve the entire word at once,"
    puts "save their game to a file, or exit the game without saving."
    puts "The player is allowed 6 mistakes, after which the game will be"
    puts "terminated. At the beginning, you are given the option to either"
    puts "start a new game or reload a previous game from a file. If you"
    puts "choose to load a previous game, it will place you back exactly"
    puts "where you were when you chose to save it.\n"
  end

  def self.game_saved
    puts "\n\nYour game has been saved!"
  end

  def self.no_games_found
    print "\n\nThere are no saved game files in the current directory."
    print "\nPut your game files in the current directory and try again."
  end

  def self.game_won(turn_count, word_spaces)
    Display::word_spaces_printer(word_spaces)
    puts "You found the word in #{turn_count} turns!\n"
  end

  def self.game_lost(mistake_count, word_spaces)
    Display::word_spaces_printer(word_spaces)
    puts "\n\nYou failed to find the word in under #{mistake_count} mistakes.\n"
  end

  def self.game_exit
    puts "\n\nThank you for playing, goodbye!\n\n"
  end
end