require_relative 'participant'
require_relative 'player'
require_relative 'dealer'
require_relative 'deck'
require_relative 'bank'

class Round
  attr_accessor :player, :dealer, :deck, :bank, :game_bank

  def initialize(player_name)
    @player = Player.new(player_name)
    @dealer = Dealer.new
    @deck = Deck.new
    @game_bank = Bank.new
  end

  def play
    start_game
    player_turn
    dealer_turn unless game_over?
    determine_winner
  end

  def start_game
    puts 'Start a new round!'

    if @game_bank.player_balance < 10 || @game_bank.dealer_balance < 10
      puts 'Not enough funds to make a bet!'
      return
    end

    2.times do
      player.add_card(deck.deal_card)
      dealer.add_card(deck.deal_card)
    end

    puts "#{@player.name} hand: #{@player.hand.map(&:to_s).join(', ')} - Total points: #{@player.total_points}"
    puts "#{@dealer.name} hand: ☆, ☆"

    @game_bank.place_auto_bet
  end

  def player_turn
    puts "It's your turn!"
    loop do
      puts 'Choose an action: (1) Skip the move, (2) Add a card, (3) Open cards'
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
        puts 'Opening cards '
        break
      else
        puts 'Invalid option!'
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

    # Проверка на превышение 21
    if player_total > 21
      puts "#{@player.name} busts! Dealer wins!"
      @game_bank.add_dealer_funds(10)
    elsif dealer_total > 21
      puts "Dealer busts! #{@player.name} wins!"
      @game_bank.add_player_funds(10)
    elsif player_total > dealer_total
      # Определение победителя
      puts "#{@player.name} wins!"
      @game_bank.add_player_funds(10)
    elsif dealer_total > player_total
      puts 'Dealer wins!'
      @game_bank.add_dealer_funds(10)
    else
      puts "It's a draw!"
      @game_bank.player_balance += 5
      @game_bank.player_balance += 5
    end

    @game_bank.display_balances
  end
end
