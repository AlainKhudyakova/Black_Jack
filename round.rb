require_relative 'participant'
require_relative 'player'
require_relative 'dealer'
require_relative 'deck'
require_relative 'bank'

class Round
  attr_accessor :player, :dealer, :deck, :game_bank

  def initialize(player_name, game_bank)
    @player = Player.new(player_name)
    @dealer = Dealer.new
    @deck = Deck.new
    @game_bank = game_bank
    @bet_amount = 10
  end

  def play
    start_game
    player_turn unless game_over?
    dealer_turn unless game_over?
    determine_winner
    @game_bank.display_balances
  end

  def start_game
    puts 'Start a new round!'

    if @game_bank.player_balance < @bet_amount || @game_bank.dealer_balance < @bet_amount
      puts 'Not enough funds to make a bet!'
      return
    end

    2.times do
      player.add_card(deck.deal_card)
      dealer.add_card(deck.deal_card)
    end

    puts "#{@player.name} hand: #{@player.hand.map(&:to_s).join(', ')} - Total points: #{@player.total_points}"
    puts "#{@dealer.name} hand: ☆, ☆"

    @game_bank.place_auto_bet(@bet_amount)
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
    @player.hand.size >= 3 || @dealer.total_points >= 21 || @player.total_points >= 21
  end

  def determine_winner
    player_total = player.total_points
    dealer_total = dealer.total_points

    puts "#{@player.name}'s total points: #{player_total}"
    puts "#{@dealer.name}'s total points: #{dealer_total}"

    # Проверка на превышение 21
    if player_total > 21
      puts "#{@player.name} busts! Dealer wins!"
      puts "Before: Player balance: #{@game_bank.player_balance}, Dealer balance: #{@game_bank.dealer_balance}"
      @game_bank.add_dealer_funds(@bet_amount)  

      puts "After: Player balance: #{@game_bank.player_balance}, Dealer balance: #{@game_bank.dealer_balance}"
    elsif dealer_total > 21
      puts "Dealer busts! #{@player.name} wins!"
      puts "Before: Player balance: #{@game_bank.player_balance}, Dealer balance: #{@game_bank.dealer_balance}"
      @game_bank.add_player_funds(@bet_amount)   

      puts "After: Player balance: #{@game_bank.player_balance}, Dealer balance: #{@game_bank.dealer_balance}"
    elsif player_total > dealer_total
      puts "#{@player.name} wins!"
      puts "Before: Player balance: #{@game_bank.player_balance}, Dealer balance: #{@game_bank.dealer_balance}"
      @game_bank.add_player_funds(@bet_amount * 2)  

      puts "After: Player balance: #{@game_bank.player_balance}, Dealer balance: #{@game_bank.dealer_balance}"
    elsif dealer_total > player_total
      puts 'Dealer wins!'
      puts "Before: Player balance: #{@game_bank.player_balance}, Dealer balance: #{@game_bank.dealer_balance}"
      @game_bank.add_dealer_funds(@bet_amount * 2)  

      puts "After: Player balance: #{@game_bank.player_balance}, Dealer balance: #{@game_bank.dealer_balance}"
    else
      puts "It's a draw!"
      puts "Before: Player balance: #{@game_bank.player_balance}, Dealer balance: #{@game_bank.dealer_balance}"
      @game_bank.add_player_funds(@bet_amount / 2) 
      @game_bank.add_dealer_funds(@bet_amount / 2)
      puts "After: Player balance: #{@game_bank.player_balance}, Dealer balance: #{@game_bank.dealer_balance}"
    end
  end
end
