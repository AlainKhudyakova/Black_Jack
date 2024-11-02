class Card
  attr_accessor :rank, :suit

  VALUES = {
    '2' => 2, '3' => 3, '4' => 4, '5' => 5,
    '6' => 6, '7' => 7, '8' => 8, '9' => 9,
    '10' => 10, 'J' => 10, 'Q' => 10, 'K' => 10, 'A' => 1
  }

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def value
    @rank == 'A' ? [1, 11] : VALUES[@rank]
  end
end

class Player
  attr_accessor :name, :bank, :hand

  def initialize(name)
    @name = name
    @bank = 100
    @hand = []
  end

  def total_points
    total = 0
    ace_count = 0

    @hand.each do |card|
      if card.rank == 'A'
        ace_count += 1
        total += 1
      else
        total += card.value
      end
    end

    ace_count.times do
      total += 10 if total + 10 <= 21
    end

    total
  end

  def add_card(card)
    @hand << card
  end

  def place_bet(amount)
    @bank -= amount
  end
end

class Dealer < Player
  def should_hit?
    total_points < 17
  end
end

class Game
  attr_accessor :player, :dealer, :deck, :pot

  def initialize(player_name = "Player")
    @player = Player.new(player_name)
    @dealer = Dealer.new("Dealer")
    @deck = create_deck.shuffle
    @pot = 20  # Ставки по 10 от игрока и дилера
  end

  def create_deck
    ranks = ['2', '3', '4', '5', '6', '7', '8', '9', '10', 'J', 'Q', 'K', 'A']
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
    
    # Простой ход игрока
    if player.hand.length == 2
      player.add_card(deck.pop)  # Игрок берет одну карту
    end
    
    puts "#{player.name}'s cards after hit: #{player.hand.map { |c| "#{c.rank}#{c.suit}" }} (Total: #{player.total_points})"
    
    if dealer.should_hit?
      dealer.add_card(deck.pop)  # Дилер берет карту, если нужно
    end

    # Определение победителя
    determine_winner
  end

  def determine_winner
    player_points = player.total_points
    dealer_points = dealer.total_points

    puts "Dealer's cards revealed: #{dealer.hand.map { |c| "#{c.rank}#{c.suit}" }} (Total: #{dealer_points})"
    
    if player_points > 21
      puts "#{player.name} проиграл!"
    elsif dealer_points > 21 || player_points > dealer_points
      puts "#{player.name} выиграл!"
    elsif player_points < dealer_points
      puts "Dealer выиграл!"
    else
      puts "Ничья!"
    end
  end
end
