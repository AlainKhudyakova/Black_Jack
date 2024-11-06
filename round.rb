require_relative 'participant'
require_relative 'player'
require_relative 'dealer'
require_relative 'deck'

class Round
  attr_accessor :player, :dealer, :deck

  def initialize(player_name)
    @player = Player.new(player_name)
    @dealer = Dealer.new
    @deck = Deck.new
  end

  def play
    start_game
    player_turn
    dealer_turn unless game_over?
    determine_winner
  end

  def start_game
    puts "Start a new round!"

    2.times do
      player.add_card(deck.deal_card)
      dealer.add_card(deck.deal_card)
    end

    puts "#{@player.name} hand: #{@player.hand.map(&:to_s).join(', ')} - Total points: #{@player.total_points}"
    puts "#{@dealer.name} hand: ☆, ☆"

    player.place_bet(10)
    dealer.place_bet(10)
  end

  def player_turn
    puts "It's your turn!"
    loop do
      puts "Choose an action: (1) Skip the move, (2) Add a card, (3) Open cards"
      choice = gets.chomp.to_i

      case choice
      when 1
        puts "#{@player.name} skips the turn"
        break
      when 2
        if @player.hand.size < 3
          @player.add_card(@deck.deal_card)
          puts "#{@player.name} draws a card: #{@player.hand.last}"
          puts "Total points: #{@player.total_points}"
        else
          puts "You can't draw more than 3 cards"
        end
      when 3
        puts "Opening cards "
        break
      else
        puts "Invalid option!"
      end
    end
  end

  def dealer_turn
    puts "Dealer's turn"
    while @dealer.should_hit?
      @dealer.add_card(@deck.deal_card)
      puts "#{@dealer.name} draws a card: #{@dealer.hand.last}"
    end
  end

  def game_over?
    @player.hand.size >= 3 || @dealer.total_points >= 21
  end

  def determine_winner
    player_total = player.total_points
    dealer_total = dealer.total_points

    puts "#{@player.name}'s total points: #{player_total}"
    puts "#{@dealer.name}'s total points: #{dealer_total}"

    if player_total > 21
      puts "#{@player.name} busts! Dealer wins!"
    elsif dealer_total > 21
      puts "Dealer busts! #{@player.name} wins!"
    elsif player_total > dealer_total
      puts "#{@player.name} wins!"
    elsif dealer_total > player_total
      puts "Dealer wins!"
    else
      puts "It's a draw!"
    end
  end
end
