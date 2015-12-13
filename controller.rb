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

  def game_file_manager
    @game_file_manager ||= GameFileManager.new
  end

  def executioner_factory
    Executioner.new(dictionary.dictionary_list)
  end

  def game_factory(executioner)
    Game.new(get_user_input, game_file_manager, executioner)
  end

  def do_load_game
    file_list = game_file_manager.game_file_list
    if file_list.empty?
      Message::no_games_found
    else
      game_num = get_user_input.file_selector(file_list)
      game_file_manager.load_game(file_list[game_num]).do_game
    end
  end

  def start
    Message::welcome_rules
    until self.continue == 'no'
      answer = get_user_input.load_or_new
      if answer == "load"
        do_load_game
      else
        game_factory(executioner_factory).do_game
      end
      self.continue = nil
      until self.continue == 'yes' || self.continue == 'no'
        self.continue = get_user_input.play_again
      end
    end
    Message::game_exit
  end
end

class Game
  attr_accessor :get_user_input, :remaining_mistakes, :executioner,
    :turn_count, :game_file_manager, :game_exit
  def initialize(get_user_input, game_file_manager, executioner)
    @get_user_input = get_user_input
    @game_file_manager = game_file_manager
    @executioner = executioner
    @remaining_mistakes = 6
    @turn_count = 0
    @game_exit = false
  end

  def do_letter(letter)
    self.remaining_mistakes -= 1 unless executioner.letter_placer(letter)
  end

  def do_solve(word)
    if executioner.secret_word == word
      executioner.word_spaces_finisher
    else
      self.remaining_mistakes -= 1
    end
  end

  def game_flow
    Display::current_word_spaces(executioner.word_spaces, remaining_mistakes,
      executioner.guess_array)
    decision = get_user_input.get_decision
    case decision
    when "guess"
      do_letter(get_user_input.get_letter(executioner.word_spaces,
        executioner.guess_array))
    when "solve"
      do_solve(get_user_input.get_word)
    when "save"
      file_name = get_user_input.get_file_name
      Message::game_saved if game_file_manager.save_game(self, file_name)
      self.game_exit = true
    when "exit"
      self.game_exit = true
    end
    self.turn_count += 1
  end

  def do_game
    until (remaining_mistakes == 0) || (executioner.word_spaces.join == \
      executioner.secret_word || game_exit)
      game_flow
    end
    if remaining_mistakes == 0
      executioner.word_spaces_finisher
      Message::game_lost(6, executioner.word_spaces)
    elsif executioner.word_spaces.join == executioner.secret_word
      Message::game_won(turn_count, executioner.word_spaces)
    end
  end
end

class GetUserInput
  def get_decision
    choices_array = ["guess", "solve", "save", "exit"]
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

  def file_selector(file_list)
    choices_array = (1..file_list.length).to_a
    decision = nil
    until choices_array.include?(decision)
      decision = Prompt::file_selector(file_list, choices_array)
      decision = decision.to_i
    end
    decision - 1
  end
end

### GAME STARTER ###
GameCycler.new.start