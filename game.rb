require_relative 'round'
require_relative 'bank'

class Game
  attr_accessor :round, :bank

  def initialize(player_name)
    @bank = Bank.new
    @round = Round.new(player_name, @bank)
  end

  def start
    loop do
      @round.play
      puts 'Do you want to play again? (yes/no)'
      answer = gets.chomp.downcase
      break if answer != 'yes'

      @round = Round.new(@round.player.name, @bank)
    end
  end
end

puts 'Welcome to the game! Please enter your name:'
player_name = gets.chomp
game = Game.new(player_name)
game.start
