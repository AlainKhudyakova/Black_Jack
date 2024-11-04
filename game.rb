require_relative 'participant'
require_relative 'dealer'
require_relative 'player'
require_relative 'card'


class Game
  attr_accessor :player, :dealer, :deck, :pot

  def initialize(player_name)
    @player = Player.new(player_name)
    @dealer = Dealer.new('Dealer')
    @deck = create_deck.shuffle
    @pot = 20 # Ставки по 10 от игрока и дилера
  end

  def create_deck
    ranks = %w[2 3 4 5 6 7 8 9 10 J Q K A]
    suits = ['К+', 'К<3', 'К^', 'К<>']
    deck = []

    suits.each do |suit|
      ranks.each do |rank|
        deck << Card.new(rank, suit)
      end
    end
    deck
  end

  def start_game
    2.times do
      player.add_card(deck.pop)
      dealer.add_card(deck.pop)
    end

    player.place_bet(10)
    dealer.place_bet(10)

    puts "#{player.name}'s cards: #{player.hand.map { |c| "#{c.rank}#{c.suit}" }} (Total: #{player.total_points})"
    puts "Dealer's cards: (Total: ???)"

    # Ход игрока
    if player.hand.length == 2
      player.add_card(deck.pop)  # Игрок берет одну карту
    end

    puts "#{player.name}'s cards after hit: #{player.hand.map do |c|
      "#{c.rank}#{c.suit}"
    end} (Total: #{player.total_points})"

    if dealer.should_hit?
      dealer.add_card(deck.pop)  # Дилер берет карту
    end

    # Определение победителя
    determine_winner
  end

  def determine_winner
    player_points = player.total_points
    dealer_points = dealer.total_points

    puts "Dealer's cards revealed: #{dealer.hand.map { |c| "#{c.rank}#{c.suit}" }} (Total: #{dealer_points})"

    if player_points > 21
      puts "#{player.name} lost!"
    elsif dealer_points > 21 || player_points > dealer_points
      puts "#{player.name} won!"
    elsif player_points < dealer_points
      puts 'The dialer won!'
    else
      puts 'Draw'
    end
  end
end
