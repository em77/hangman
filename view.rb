module Display
  def self.current_word_spaces(word_spaces, remaining_turns, guess_array)
    print "\n\n#{word_spaces.join(' ').upcase}\n\n"
    print "Your guesses: #{guess_array.join(", ")}\n\n"
    print "#{remaining_turns} mistakes remaining\n\n"
  end
end

module Prompt
  def self.load_or_new(choices_array)
    print "\n\nWould you like to start a new game or load a previous game?"
    decision(choices_array)
  end

  def self.playing_decision(choices_array)
    print "\n\nWhat would you like to do? You can guess a letter, attempt to" +
    " solve the entire word, or save your game to come back to later."
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
    gets.chomp.downcase.gsub(/\s+/, "")
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
    #
  end

  def self.game_saved
    puts "\n\nYour game has been saved!"
  end

  def self.game_won(turn_count)
    puts "\n\nYou found the word in #{turn_count} turns!\n"
  end

  def self.game_lost(total_turns)
    puts "\n\nYou failed to find the word in the limit of #{total_turns}.\n"
  end

  def self.exit
    puts "\n\nThank you for playing, goodbye!\n\n"
  end
end