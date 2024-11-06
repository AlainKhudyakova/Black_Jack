class Card
  attr_accessor :rank, :suit

  SUITS = ['♠', '♥', '♦', '♣']
  RANKS = %w[2 3 4 5 6 7 8 9 10 J Q K A]

  def initialize(rank, suit)
    @rank = rank
    @suit = suit
  end

  def value
    case rank
    when 'A' then 11
    when 'K', 'Q', 'J' then 10
    else rank.to_i
    end
  end

  def to_s
    "#{rank}#{suit}"
  end
end
