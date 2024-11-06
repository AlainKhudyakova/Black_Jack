require_relative 'card'

class Deck
  
  def initialize
    @cards = create_deck
    shuffle_deck
  end

  def create_deck
    Card::SUITS.product(Card::RANKS).map { |suit, rank| Card.new(rank,suit)}
  end

  def shuffle_deck
    @cards.shuffle
  end

  def deal_card
    if @cards.empty?
      puts "Deck is empty, creatinf a new deck"
      @cards = create_deck
      shuffle_deck
    end
    @cards.pop
  end
end