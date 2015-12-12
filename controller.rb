require_relative 'model'
require_relative 'view'

class GameCycler
  attr_accessor :continue
  def initialize
    @continue = nil
  end

  def get_user_input
    @get_user_input ||= GetUserInput.new
  end

  def dictionary
    @dictionary ||= Dictionary.new(5, 12, "dictionary.txt")
  end

  def game_factory(dictionary_list)
    Game.new(get_user_input, dictionary_list)
  end

  def start
    Message::welcome_rules
    until self.continue == 'no'
      answer = get_user_input.load_or_new
      if answer == "load"
        #
      else
        game_factory(dictionary.dictionary_list).do_game
      end
      self.continue = nil
      until self.continue == 'yes' || self.continue == 'no'
        self.continue = get_user_input.play_again
      end
    end
    Message::exit
  end
end

class Game
  attr_accessor :get_user_input, :remaining_mistakes, :dictionary_list,
    :turn_count
  def initialize(get_user_input, dictionary_list)
    @get_user_input = get_user_input
    @dictionary_list = dictionary_list
    @remaining_mistakes = 6
    @turn_count = 0
  end

  def executioner
    @executioner ||= Executioner.new(dictionary_list)
  end

  def do_letter(letter)
    self.remaining_mistakes -= 1 unless executioner.letter_placer(letter)
  end

  def do_solve(word)
    executioner.word_spaces_finisher if executioner.secret_word == word
  end

  def game_flow
    Display::current_word_spaces(executioner.word_spaces, remaining_mistakes,
      executioner.guess_array)
    puts "remaining_mistakes: #{remaining_mistakes}"
    puts executioner.secret_word
    decision = get_user_input.get_decision
    case decision
    when "guess"
      do_letter(get_user_input.get_letter(executioner.word_spaces,
        executioner.guess_array))
    when "solve"
      do_solve(get_user_input.get_word)
    when "save"
      #
    end
    self.turn_count += 1
  end

  def do_game
    until (remaining_mistakes == 0) || (executioner.word_spaces.join == \
      executioner.secret_word)
      game_flow
    end
    if remaining_mistakes == 0
      Message::game_lost(6)
    else
      Message::game_won(turn_count)
    end
  end
end

class GetUserInput
  def get_decision
    choices_array = ["guess", "solve", "save"]
    decision = nil
    until choices_array.include?(decision)
      decision = Prompt::playing_decision(choices_array)
    end
    decision
  end

  def load_or_new
    choices_array = ["load", "new"]
    decision = nil
    until choices_array.include?(decision)
      decision = Prompt::load_or_new(choices_array)
    end
    decision
  end

  def play_again
    choices_array = ["yes", "no"]
    decision = nil
    until choices_array.include?(decision)
      decision = Prompt::play_again(choices_array)
    end
    decision
  end

  def get_letter(word_spaces, guess_array)
    letter = "letter"
    until (letter.length == 1) && !(guess_array.include?(letter))
      letter = Prompt::letter
    end
    letter
  end

  def get_word
    word = ""
    while word.empty?
      word = Prompt::word
    end
    word
  end

  def get_file_name
    name = ""
    while name.empty?
      name = Prompt::file_name
    end
    name
  end
end

### GAME STARTER ###
GameCycler.new.start