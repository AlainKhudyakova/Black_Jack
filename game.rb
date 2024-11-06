require_relative 'round'

class Game
  attr_accessor :round


  def initialize(player_name)
    #@player = Participant.new(player_name)
    #@dealer = Dealer.new
    @round = Round.new(player_name)
  end

  def start
    loop do
      @round.play
      puts "Do you want to play again? (yes/no)"
      answer = gets.chomp.downcase
      break if answer != 'yes'

      @round = Round.new(@round.player.name)
    end
  end
end

puts "Welcome to the game! Please enter your name:"
player_name = gets.chomp
game = Game.new(player_name)
game.start
