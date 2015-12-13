## Hangman in Ruby

This is a command-line based Hangman game written in Ruby where
the computer generates a random word from the dictionary and the
player must attempt to figure out what the word is. By utilizing
YAML serialization, a player can choose to save their game or
load a previous game.

####RULES
The computer selects a random word that is symbolized by empty
dashes, each dash corresponding to a letter of the word. The
object of the game is to guess the word in as few turns as
possible. Each turn, the player is given the option to guess a
letter of the word, attempt to solve the entire word at once,
save their game to a file, or exit the game without saving.
The player is allowed 6 mistakes, after which the game will be
terminated. At the beginning, you are given the option to either
start a new game or reload a previous game from a file. If you
choose to load a previous game, it will place you back exactly
where you were when you chose to save it.

To run the game, enter `ruby controller.rb` at your command-line.